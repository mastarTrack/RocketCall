//
//  CreateMissionViewModel.swift
//  RocketCall
//
//  Created by 손영빈 on 3/25/26.
//

import Foundation
import RxSwift
import RxCocoa

class CreateMissionViewModel {
    
    private let disposeBag = DisposeBag()
    private let coreDataManager: CoreDataManager
    private let errorSubject = PublishSubject<CoreDataManager.CoreDataError>()
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    struct Input {
        let missionName: Observable<String>
        let studyTime: Observable<Int>
        let restTime: Observable<Int>
        let cycleCount: Observable<Int>
        let quickItemSelected: Observable<Int>
        let createButtonTapped: Observable<Void>
    }
    
    struct Output {
        let totalTime: Observable<String>
        let intervalText: Observable<String>
        let selectedQuickItem: Observable<Int?>
        let quickStudyTime: Observable<Int>
        let quickRestTime: Observable<Int>
        let isCreateButtonEnabled: Observable<Bool>
        let success: Observable<Void>
        let error: Observable<CoreDataManager.CoreDataError>
    }
    
    func transform(input: Input) -> Output {
        
        let time = Observable
            .combineLatest(input.studyTime, input.restTime, input.cycleCount)
        // 총 소요 시간
        let totalTime = time
            .map { studyTime, restTime, cycleCount in
                let total = (studyTime + restTime) * cycleCount
                let hour = total / 60
                let minute = total % 60
                if hour > 0 {
                    return "\(hour)시간 \(minute)분"
                } else {
                    return "\(minute)분"
                }
            }
        
        // 반복 주기
        let intervalText = time
            .map { studyTime, restTime, cycleCount in
                return "\(studyTime + restTime) x \(cycleCount)회 반복" // 정하고 수정 필요
            }
        
        let quickItem: [(studyTime: Int, restTime: Int)] = [
            (25, 5), (50, 10), (90, 20), (120, 20)
        ]
        // 빠른 선택 아이템의 Index 가져오기, 다시 선택 시 취소
        let selectedQuickItem: Observable<Int?> = input.quickItemSelected
            .scan(nil as Int?) { current, selected in
                current == selected ? nil : selected
            }
            .share() // quickStudyTime, quickRestTime에서 사용 -> 공유
        
        let quickStudyTime = selectedQuickItem
            .compactMap { $0 }
            .map { quickItem[$0].studyTime }
        
        let quickRestTime = selectedQuickItem
            .compactMap { $0 }
            .map { quickItem[$0].restTime }
        
        // 버튼 활성화 비활성화
        let isCreatedButtonEnabled = Observable
            .combineLatest(input.missionName, input.studyTime, input.cycleCount)
            .map { missionName, studyTime, cycleCount in
                !missionName.isEmpty && studyTime >= 1 && cycleCount >= 1
            }
        
        // 저장 성공, 실패
        let success = input.createButtonTapped
            .flatMap {
                Observable.combineLatest(
                    input.missionName,
                    input.studyTime,
                    input.restTime,
                    input.cycleCount
                ).take(1)
            }
            .flatMap { [weak self] (missionName, studyTime, restTime, cycleCount) -> Observable<Void> in
                guard let self else { return .empty() }
                let mission = MissionPayload(
                    id: UUID(),
                    title: missionName,
                    concentrateTime: studyTime,
                    breakTime: restTime,
                    cycle: cycleCount
                )
                do {
                    try self.coreDataManager.createMissionEntity(mission: mission)
                    print("저장 성공.\n title: \(missionName), concentrateTime: \(studyTime), breakTime: \(restTime), cycle: \(cycleCount)")
                    return .just(())
                } catch let error as CoreDataManager.CoreDataError {
                    self.errorSubject.onNext(error)
                    return .empty()
                }
            }
        
        return Output(
            totalTime: totalTime,
            intervalText: intervalText,
            selectedQuickItem: selectedQuickItem,
            quickStudyTime: quickStudyTime,
            quickRestTime: quickRestTime,
            isCreateButtonEnabled: isCreatedButtonEnabled,
            success: success,
            error: errorSubject.asObservable()
        )
    }
}
