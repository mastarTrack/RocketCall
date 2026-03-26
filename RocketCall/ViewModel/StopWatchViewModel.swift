//
//  StopWatchViewModel.swift
//  RocketCall
//
//  Created by Hanjuheon on 3/25/26.
//

import Foundation
import RxSwift
import RxRelay


/// StopWatch ViewModel
class StopWatchViewModel {
    
    enum state {
        case idle
        case run
        case pause
    }
    
    private var temptime = 0
    
    /// View -> ViewModel Action
    struct Input {
        let startPause: Observable<Bool>
        //let stop: Observable<Void>
    }
    
    /// ViewModel -> View  Action
    struct Output {
        let timer: Observable<String>
    }
    
    /// RxSwif t변환 메소드
    func transform(_ input: Input) -> Output {
        let timer = input.startPause
            .flatMapLatest{ isRun -> Observable<Int> in
                if isRun {
                    return Observable<Int>.interval(.milliseconds(10), scheduler: MainScheduler.asyncInstance)
                        .map{ _ in 1 }
                } else {
                    return .empty()
                }
            }
            .scan(0) { cumulative, newValue in
                cumulative + newValue
            }
            .startWith(0)
            .map { [weak self] time in
                guard let self else { return "00:00.00" }
                return self.formatTime(time)
            }
        
        return Output(timer: timer)
    }
    
    
    private func formatTime(_ centiseconds: Int) -> String {
        let minutes = centiseconds / 6000
        let seconds = (centiseconds % 6000) / 100
        let cs = centiseconds % 100
        
        return String(format: "%02d:%02d.%02d", minutes, seconds, cs)
    }
}
