//
//  TimerAnimationViewModel.swift
//  RocketCall
//
//  Created by Yeseul Jang on 3/27/26.
//
import Foundation
import RxSwift
import RxCocoa
import UIKit

class TimerAnimationViewModel: ViewModelProtocol {
    struct Input {
        let activatedMissionState: Observable<ActivatedMissionPayload> // 실제 타이머 정보
        let stopButtonTapped: Observable<Void>
        let missionStopButtonTapped: Observable<Void>
        let backButtonTapped: Observable<Void>
    }
    
    struct Output {
        let missionTitleText: Observable<String>
        let timerText: Observable<String>
        let cycleText: Observable<String>
        let remainingTime: Observable<TimeInterval>
        let totalDuration: Observable<TimeInterval>
        let stopButtonImage: Observable<UIImage?>
        let pauseResumeRequested: Observable<Void>
        let routeStopMission: Observable<Void>
        let routeBack: Observable<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let missionState = input.activatedMissionState
            .share(replay: 1, scope: .whileConnected)
        
        let missionTitle = missionState
            .map { $0.mission.title }
        
        let totalDuration = missionState
            .map { mission -> TimeInterval in
                let minutes = mission.isConcentrating ? mission.mission.concentrateTime : mission.mission.breakTime
                return TimeInterval(minutes * 60)
            }
        
        let remainingTime = missionState
            .map { TimeInterval($0.remainingTime) }
        
        let timerText = remainingTime
            .map(Self.formatTime)
        
        let cycleText = missionState
            .map { "\($0.currentCycle) / \($0.mission.cycle) 사이클" }
        
        let stopButtonImage = missionState
            .map { mission -> UIImage? in
                UIImage(systemName: mission.isPaused ? "play.fill" : "pause.fill")
            }
        
        return Output(
            missionTitleText: missionTitle,
            timerText: timerText,
            cycleText: cycleText,
            remainingTime: remainingTime,
            totalDuration: totalDuration,
            stopButtonImage: stopButtonImage,
            pauseResumeRequested: input.stopButtonTapped,
            routeStopMission: input.missionStopButtonTapped,
            routeBack: input.backButtonTapped
        )
    }
}

private extension TimerAnimationViewModel {
    static func formatTime(_ timeInterval: TimeInterval) -> String {
        let totalSeconds = max(0, Int(timeInterval))
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
