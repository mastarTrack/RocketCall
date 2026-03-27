//
//  TimerViewModel.swift
//  RocketCall
//
//  Created by 손영빈 on 3/26/26.
//

import Foundation
import RxSwift
import RxCocoa
import UserNotifications

class TimerViewModel: ViewModelProtocol {
    
    private let disposeBag = DisposeBag()
    private let coreDataManager: CoreDataManager
    private let activatedMissionRelay = BehaviorRelay<[ActivatedMissionPayload]>(value: [])
    private let errorSubject = PublishSubject<CoreDataManager.CoreDataError>()
    
    var backgroundEnterTime: Date?
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    struct Input {
        let activatedMission: Observable<MissionPayload>
        let pauseResumeButtonTapped: Observable<UUID>
        let stopButtonTapped: Observable<UUID>
    }
    
    struct Output {
        let activatedMissions: Observable<([ActivatedMissionPayload], Bool)>
        let error: Observable<CoreDataManager.CoreDataError>
    }
    
    func transform(_ input: Input) -> Output {
        
        // 미션 활성화
        input.activatedMission
            .subscribe(onNext: { [weak self] mission in
                guard let self else { return }
                let activatedMission = ActivatedMissionPayload( // MissionPayload -> ActivatedMissionPayload 변환
                    id: UUID(),
                    mission: mission,
                    currentCycle: 1,
                    remainingTime: mission.concentrateTime * 60,
                    isConcentrating: true,
                    startDate: Date(),
                    isPaused: false,
                    studyTime: 0,
                    pausedTime: 0
                )
                var current = self.activatedMissionRelay.value
                current.append(activatedMission)
                self.activatedMissionRelay.accept(current) // Relay 배열에 추가
            })
            .disposed(by: disposeBag)
        
        // 1초마다 실행되는 타이머 (하나로 모두 관리)
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                let updated = self.activatedMissionRelay.value.compactMap { mission -> ActivatedMissionPayload? in
                    if mission.isPaused {
                        var updated = mission
                        updated.pausedTime += 1
                        return updated
                    }
                    var updated = self.updateMission(mission)
                    if mission.isConcentrating {
                        updated?.studyTime += 1
                    }
                    return updated
                }
                self.activatedMissionRelay.accept(updated) // 수정된 배열 다시 넣기
            })
            .disposed(by: disposeBag)
        
        // 목록 추가/제거 -> 애니메이션 적용
        let activatedMissions = activatedMissionRelay
            .distinctUntilChanged { $0.count == $1.count }
            .map{ ($0, true) }
        
        // 타이머 업데이트 -> 애니메이션 제거
        let timerUpdate = activatedMissionRelay
            .map { ($0, false) }
        
        input.pauseResumeButtonTapped
            .subscribe(onNext: { [weak self] uuid in
                guard let self else { return }
                let updated = self.activatedMissionRelay.value.map { mission -> ActivatedMissionPayload in
                    guard mission.id == uuid else { return mission }
                    var updated = mission
                    updated.isPaused.toggle()
                    return updated
                }
                self.activatedMissionRelay.accept(updated)
            })
            .disposed(by: disposeBag)
        
        input.stopButtonTapped
            .subscribe(onNext: { [weak self] uuid in
                guard let self else { return }
                guard let mission = self.activatedMissionRelay.value.first(where: { $0.id == uuid }) else { return }
                self.saveMission(mission: mission, isCompleted: false)
                let updated = self.activatedMissionRelay.value.filter { $0.id != uuid }
                self.activatedMissionRelay.accept(updated)
            })
            .disposed(by: disposeBag)
        
        return Output(
            activatedMissions: Observable.merge(activatedMissions, timerUpdate),
            error: errorSubject.asObservable()
        )
    }
    
    // 미션 상태 변경 로직
    private func updateMission(_ mission: ActivatedMissionPayload) -> ActivatedMissionPayload? {
        
        var updated = mission
        updated.remainingTime -= 1 // 1초 감소
        
        guard updated.remainingTime <= 0 else { return updated } // 남은 시간이 있으면 반환
        
        if updated.isConcentrating { // 집중 시간 종료 -> 휴식 시간으로 변경
            if updated.mission.breakTime == 0 {
                if updated.currentCycle < updated.mission.cycle { // 집중 시간 -> 집중 시간
                    updated.currentCycle += 1
                    updated.remainingTime = updated.mission.concentrateTime * 60
                    updated.isConcentrating = true
                    return updated
                }
                saveMission(mission: mission, isCompleted: true) // 집중 시간 -> 사이클 종료
                return nil
            }
            
            updated.remainingTime = updated.mission.breakTime * 60
            updated.isConcentrating = false
            return updated
        }
        
        if updated.currentCycle < updated.mission.cycle { // 휴식 시간 종료 -> 다음 사이클로 변경
            updated.currentCycle += 1
            updated.remainingTime = updated.mission.concentrateTime * 60
            updated.isConcentrating = true
            return updated
        }
        // 모든 사이클 종료 -> CoreData저장 -> nil 반환 -> 배열에서 제거
        saveMission(mission: mission, isCompleted: true)
        return nil
    }
    
    private func saveMission(mission: ActivatedMissionPayload, isCompleted: Bool) {
        let result = MissionResultPayload(
            id: UUID(),
            title: mission.mission.title,
            start: mission.startDate,
            end: Date(),
            studyTime: mission.studyTime,
            isCompleted: isCompleted
        )
        do {
            try coreDataManager.createMissionResultEntity(result: result)
            print("저장 완료, 공부 시간 :\(result.studyTime)")
        } catch {
            if let coreDataError = error as? CoreDataManager.CoreDataError {
                errorSubject.onNext(coreDataError)
            } else {
                errorSubject.onNext(.saveFailed)
            }
        }
    }
    
    func enterForeGround() {
        guard let backgroundEnterTime else { return }
        let elapsed = Int(Date().timeIntervalSince(backgroundEnterTime))
            self.backgroundEnterTime = nil
            
            let updated = activatedMissionRelay.value.compactMap { mission -> ActivatedMissionPayload? in
                guard !mission.isPaused else {
                    var updated = mission
                    updated.pausedTime += elapsed
                    return updated
                }
                return (0..<elapsed).reduce(Optional(mission)) { current, _ in
                    guard let current else { return nil }
                    let isConcentrating = current.isConcentrating
                    var updated = updateMission(current)
                    if isConcentrating {
                        updated?.studyTime += 1
                    }
                    return updated
                }
            }
            activatedMissionRelay.accept(updated)
    }
    
    
    func cycleNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        for mission in activatedMissionRelay.value {
            guard !mission.isPaused else { continue }
            
            var timeOffset = mission.remainingTime
            var currentCycle = mission.currentCycle
            var isConcentrating = mission.isConcentrating
            
            while true {
                let content = UNMutableNotificationContent()
                content.sound = .default
                content.title = mission.mission.title
                
                if isConcentrating {
                    if mission.mission.breakTime == 0 {
                        if currentCycle == mission.mission.cycle {
                            // 미션 완료 알림
                            content.body = "미션 완료!"
                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeOffset), repeats: false)
                            let request = UNNotificationRequest(identifier: "timer-\(mission.id)-complete", content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request)
                            break
                        }
                        // 휴식없이 다음 사이클
                        content.body = "\(currentCycle) 사이클 집중 완료! 다음 사이클을 시작합니다."
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeOffset), repeats: false)
                        let request = UNNotificationRequest(identifier: "timer-\(mission.id)-\(currentCycle)-concentrate", content: content, trigger: trigger)
                        UNUserNotificationCenter.current().add(request)
                        currentCycle += 1
                        timeOffset += mission.mission.concentrateTime * 60
                    } else {
                        // 집중 완료 → 휴식 시작 알림
                        content.body = "\(currentCycle) 사이클 집중 완료! 휴식 시간입니다."
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeOffset), repeats: false)
                        let request = UNNotificationRequest(identifier: "timer-\(mission.id)-\(currentCycle)-concentrate", content: content, trigger: trigger)
                        UNUserNotificationCenter.current().add(request)
                        isConcentrating = false
                        timeOffset += mission.mission.breakTime * 60
                    }
                } else {
                    if currentCycle == mission.mission.cycle {
                        // 미션 완료 알림
                        content.body = "미션 완료!"
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeOffset), repeats: false)
                        let request = UNNotificationRequest(identifier: "timer-\(mission.id)-complete", content: content, trigger: trigger)
                        UNUserNotificationCenter.current().add(request)
                        break
                    }
                    // 휴식 완료 → 다음 사이클 알림
                    content.body = "\(currentCycle) 사이클 휴식 완료! 집중 시간입니다."
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeOffset), repeats: false)
                    let request = UNNotificationRequest(identifier: "timer-\(mission.id)-\(currentCycle)-rest", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request)
                    currentCycle += 1
                    isConcentrating = true
                    timeOffset += mission.mission.concentrateTime * 60
                }
            }
        }
    }
}
