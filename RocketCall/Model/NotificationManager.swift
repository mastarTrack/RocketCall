//
//  NotificationManager.swift
//  RocketCall
//
//  Created by 김주희 on 3/26/26.
//

import Foundation
import UserNotifications
import RxSwift
import RxCocoa

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    static let shared = NotificationManager()
    
    // 알람 울리면 알리기
    let alarmRingingEvent = PublishRelay<(String, UUID)>()
    
    let timerNotificationTapped = PublishRelay<Void>()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    
    // MARK: - 알람 권한 요청 메서드
    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound]
        
        center.requestAuthorization(options: options) { granted, error in
            if let error = error {
                print("Notification authorization error: \(error.localizedDescription)")
            }
        }
    }
    
    
    // MARK: - 알람 예약 메서드
    func addAlarm(_ alarm: Alarm) {
        let notificationRepeatInterval = 9
        let center = UNUserNotificationCenter.current()
        
        // 1. 내용
        let content = UNMutableNotificationContent()
        content.title = "Rocket Call"
        content.body = alarm.title // 사용자가 지정한 알람 이름
        content.sound = UNNotificationSound(named: UNNotificationSoundName("AlarmSound.wav"))
        content.interruptionLevel = .timeSensitive // 방해 금지여도 알람
        
        // 2. 시간 설정
        // 반복 없음
        if alarm.repeatDays.isEmpty {
            for i in 0..<4 {
                var dateComponents = DateComponents()
                dateComponents.hour = alarm.hour
                dateComponents.minute = alarm.minute
                dateComponents.second = i * notificationRepeatInterval
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                let identifier = "\(alarm.id.uuidString)-\(i)"
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                
                center.add(request)
            }
        } else {
            // 반복 있음
            for day in alarm.repeatDays {
                for i in 0..<4 {
                    var dateComponents = DateComponents()
                    dateComponents.weekday = day.appleWeekDay
                    dateComponents.hour = alarm.hour
                    dateComponents.minute = alarm.minute
                    dateComponents.second = i * notificationRepeatInterval
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                    let identifier = "\(alarm.id.uuidString)-\(day.rawValue)-\(i)" // id가 동일하므로 구분지어주기 위해 뒤에 요일 추가
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    
                    center.add(request)
                }
            }
        }
    }
    
    
    // MARK: - 알람 취소 메서드
    func cancelAlarm(_ id: String) {
        let center = UNUserNotificationCenter.current()
        
        center.getPendingNotificationRequests { requests in
            // 예약된 알람 중 해당 UUID가 포함된 알람만 골라내기
            let identifiersToRemove = requests
                .filter { $0.identifier.contains(id) }
                .map { $0.identifier }
            
            center.removePendingNotificationRequests(withIdentifiers: identifiersToRemove)
        }
    }
    
    
    // MARK: - 스누즈 알람 예약 메서드
    func addSnoozeAlarm(title: String, originalId: UUID) {
        let snoozeTime: TimeInterval = 60 * 5
        let center = UNUserNotificationCenter.current()
        
        // 1. 내용
        let content = UNMutableNotificationContent()
        content.title = "Rocket Call (Snooze)"
        content.body = title
        content.sound = UNNotificationSound(named: UNNotificationSoundName("AlarmSound.wav"))
        content.interruptionLevel = .timeSensitive // 방해 금지여도 알람
        
        // 2. 시간 설정
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: snoozeTime, repeats: false)
        let identifier = "\(originalId.uuidString)-Snooze"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request)
    }
    
    
    // MARK: - 앱이 화면에 켜져있을때
    var currentRingingId: UUID? = nil // 현재 울리고 있는 알람의 id값 기억하기
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // 예약할 때 넣었던 알람 제목 꺼내기
        let alarmTitle = notification.request.content.body
        let idString = String(notification.request.identifier.prefix(36))
        
        if let uuid = UUID(uuidString: idString) {
            
            if currentRingingId == uuid { // 동일한 uuid의 알람이면 알람 화면 또 띄울 필요 없음
                completionHandler([])
                return
            }
            
            currentRingingId = uuid
            alarmRingingEvent.accept((alarmTitle, uuid))
        }
        
        completionHandler([]) // 배너 띄울 필요 없으므로 빈 배열
    }
    
    
    // MARK: - 앱이 꺼져있을때 (백그라운드)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // completionHandler는 한번만 호출해야 해서 타이머인지 먼저 확인해야 해요 !
        let identifier = response.notification.request.identifier
        if identifier.hasPrefix("timer-") {
            timerNotificationTapped.accept(())
            completionHandler()
            return
        }
        
        
        let alarmTitle = response.notification.request.content.body
        let idString = String(response.notification.request.identifier.prefix(36))
        
        if let uuid = UUID(uuidString: idString) {
            alarmRingingEvent.accept((alarmTitle, uuid))
        }
        completionHandler()
    }
    
}

extension NotificationManager {
    func fetchNearestAlarm() async -> UUID? {
        let center = UNUserNotificationCenter.current()
        
        let requests = await center.pendingNotificationRequests()
        
        let request = requests
            .compactMap { request -> (request: UNNotificationRequest, date: Date)? in
                guard let trigger = request.trigger as? UNCalendarNotificationTrigger,
                      let nextTriggerDate = trigger.nextTriggerDate() else {
                    return nil
                }
                return (request, nextTriggerDate)
            }
            .sorted(by: { $0.date < $1.date })
            .first?.request
        
        guard let id = request?.identifier.prefix(36) else {
            return nil
        }

        return UUID(uuidString: String(id))
    }
}
