//
//  Untitled.swift
//  RocketCall
//
//  Created by 김주희 on 3/26/26.
//

import UIKit
import Foundation
import AVFoundation
import RxSwift
import RxCocoa
import AudioToolbox

final class AlarmRingViewController: UIViewController {
    
    private var audioPlayer: AVAudioPlayer?
    private var vibrationTimer: Timer?
    private let disposeBag = DisposeBag()
    private let alarmRingTitle: String
    private let alarmId: UUID
    private let coreDataManager = CoreDataManager()
    
    private lazy var alarmRingView: AlarmRingView = {
        let now = Date() // 현 시간 가져옴
        
        // 시간
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let currentTimeString = timeFormatter.string(from: now)
        
        // 날짜
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR") // 한국어 세팅
        dateFormatter.dateFormat = "M월 d일 EEEE"
        let currentDateString = dateFormatter.string(from: now)
        
        return AlarmRingView(time: currentTimeString, date: currentDateString, title: alarmRingTitle)
    }()
    
    init(title: String, alarmID: UUID) {
        self.alarmRingTitle = title
        self.alarmId = alarmID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    
    override func loadView() {
        view = alarmRingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playSound()
        startVibration()
        bind()
    }
    
    
    // MARK: - 소리 무한 재생
    private func playSound() {
        guard let url = Bundle.main.url(forResource: "AlarmSound", withExtension: "wav") else {
            print("사운드 파일 오류")
            return
        }
        
        do {
            // 무음모드 일때도 소리나게 하기
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: . default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            // 플레이어 세팅하기
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // 무한 반복
            audioPlayer?.volume = 1.0 // 최대 볼륨
            
            audioPlayer?.play()
        } catch {
            print("플레이어 재생 실패: \(error)")
        }
    }
    
    
    // MARK: - 진동 무한 재생
    private func startVibration() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate) // 화면 키자마자 진동
        
        // 2초에 한번씩 진동
        vibrationTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
    }
    
    
    // MARK: - 알람 해제 로직
    private func bind() {
        
        // 알람 끄기 버튼
        alarmRingView.stopButton.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.audioPlayer?.stop()
                self.vibrationTimer?.invalidate()
                self.vibrationTimer = nil
                
                NotificationManager.shared.cancelAlarm(self.alarmId) // 알람 cancel
                
                NotificationManager.shared.currentRingingId = nil
                
                do {
                    let payload = try self.coreDataManager.fetchAlarm(of: self.alarmId)
                    
                    if payload.repeatDays.isEmpty {
                        var updatedPayload = payload
                        updatedPayload.isOn = false   // 요일 반복 없는 알람이면 토글 off
                        try self.coreDataManager.updateAlarmEntity(of: updatedPayload)
                        
                        
                    } else { // 요일 반복하는 알람이면 알람 다시 등록
                        
                        // 앱이 백그라운드 상태여도 앱이 죽지않도록 요청
                        var bgTask: UIBackgroundTaskIdentifier = .invalid
                        bgTask = UIApplication.shared.beginBackgroundTask(withName: "RescheduleAlarm") {
                            // 만약 시스템이 시간을 더 이상 못 주겠다고 하면 태스크 종료
                            UIApplication.shared.endBackgroundTask(bgTask)
                            bgTask = .invalid
                        }
                            
                        // 24초 딜레이
                        DispatchQueue.global().asyncAfter(deadline: .now() + 24.0) {
                            
                            let alarmToReschedule = Alarm(
                                id: payload.id,
                                hour: payload.hour,
                                minute: payload.minute,
                                title: payload.title,
                                repeatDays: payload.repeatDays.compactMap { WeekDay(rawValue: $0) },
                                isOn: payload.isOn
                            )
                            
                            NotificationManager.shared.addAlarm(alarmToReschedule)
                            
                            // 재등록이 끝났으니,종료
                            UIApplication.shared.endBackgroundTask(bgTask)
                            bgTask = .invalid
                        }
                        
                    }
                } catch {
                        print("알람 토글 상태 업데이트 실패: \(error)")
                }
                
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        
        // 스누즈 버튼
        alarmRingView.snoozeButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.audioPlayer?.stop()
                owner.vibrationTimer?.invalidate()
                owner.vibrationTimer = nil
                
                NotificationManager.shared.addSnoozeAlarm(title: owner.alarmRingTitle, originalId: owner.alarmId)
                
                NotificationManager.shared.currentRingingId = nil

                
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
    }
}
