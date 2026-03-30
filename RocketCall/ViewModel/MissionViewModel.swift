//
//  MissionViewModel.swift
//  RocketCall
//
//  Created by 손영빈 on 3/26/26.
//

import Foundation
import RxSwift
import RxCocoa

class MissionViewModel: ViewModelProtocol {
    
    private let disposeBag = DisposeBag()
    private let coreDataManager: CoreDataManager
    
    private let errorSubject = PublishSubject<CoreDataManager.CoreDataError>()
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    struct Input {
        let initialize: Observable<Void>
    }
    
    struct Output {
        let missions: Observable<[MissionPayload]>
        let error: Observable<CoreDataManager.CoreDataError>
    }
    
    func transform(_ input: Input) -> Output {
        
        let missions = input.initialize
            .map { [weak self] _ -> [MissionPayload] in
                guard let self else { return [] }
                do {
                    return try self.coreDataManager.fetchAllMission()
                } catch {
                    if let coreDataError = error as? CoreDataManager.CoreDataError {
                        self.errorSubject.onNext(coreDataError)
                    } else {
                        self.errorSubject.onNext(.loadFailed)
                    }
                    return []
                }
            }
        
        return Output(
            missions: missions,
            error: errorSubject.asObservable()
        )
    }
}
