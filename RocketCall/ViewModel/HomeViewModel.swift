//
//  HomeViewModel.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/26/26.
//

import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelProtocol {
    struct Input {
        let fetchData: PublishRelay<Void>
    }
    
    struct Output {
        
    }
    
    let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func transform(_ input: Input) -> Output {
        return Output()
    }
}
