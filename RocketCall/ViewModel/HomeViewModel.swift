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
    
    //MARK: 속성 선언
    let coreDataManager: CoreDataManager
    let disposeBag = DisposeBag()
    
    //MARK: init
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func transform(_ input: Input) -> Output {
        input.fetchData
            .subscribe(onNext: {
                print("fetch Data")
            })
            .disposed(by: disposeBag)
        
        return Output()
    }
}
