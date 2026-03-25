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
    private let errorSubject = PublishSubject<Error>()
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    struct Input {
        let missionName: Observable<String>
        let studyTime: Observable<Int>
        let restTime: Observable<Int>
        let cycleCount: Observable<Int>
    }
    
    struct Output {
        let totalTime: Observable<String>
        let intervalText: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        
        let time = Observable
            .combineLatest(input.studyTime, input.restTime, input.cycleCount)
        
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
        
        let intervalText = time
            .map { studyTime, restTime, cycleCount in
                return "\(studyTime + restTime) x \(cycleCount)회 반복" // 정하고 수정 필요
            }
        
        return Output(
            totalTime: totalTime,
            intervalText: intervalText
        )
    }
}
