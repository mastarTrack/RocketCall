//
//  TimerViewModel.swift
//  RocketCall
//
//  Created by 손영빈 on 3/26/26.
//

import Foundation
import RxSwift
import RxCocoa

class TimerViewModel: ViewModelProtocol {
    
    private let disposeBag = DisposeBag()
    private let coreDataManager: CoreDataManager
    private let activatedMissionRelay = BehaviorRelay<[ActivatedMissionPayload]>(value: [])
    private let errorSubject = PublishSubject<CoreDataManager.CoreDataError>()
    
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
}
