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
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    struct Input {
        let activatedMission: Observable<MissionPayload>
    }
    
    struct Output {
        let activatedMissions: Observable<[ActivatedMissionPayload]>
    }
    
    func transform(_ input: Input) -> Output {
        let activatedMissions = input.activatedMission
            .scan([ActivatedMissionPayload]()) { current, new in
                let activated = ActivatedMissionPayload(
                    id: UUID(),
                    mission: new,
                    currentCycle: 1,
                    remainingTime: new.concentrateTime * 60,
                    isConcentrating: true,
                    startDate: Date(),
                    isPaused: false
                )
                return current + [activated]
            }
        return Output(activatedMissions: activatedMissions)
    }
}
