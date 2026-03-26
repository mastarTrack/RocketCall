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
    
    enum State {
        case run
        case pause
        case reset
    }
    
    enum timerAction {
        case tick
        case reset
    }
    
    private var temptime = 0
    
    /// View -> ViewModel Action
    struct Input {
        let startPause: Observable<State>
        //let stop: Observable<Void>
    }
    
    /// ViewModel -> View  Action
    struct Output {
        let timer: Observable<String>
    }
    
    /// RxSwif t변환 메소드
    func transform(_ input: Input) -> Output {
        let timer = input.startPause
            .flatMapLatest{ state -> Observable<timerAction> in
                switch state {
                case .run:
                    return Observable<Int>.interval(.milliseconds(10), scheduler: MainScheduler.asyncInstance)
                        .map{ _ in .tick }
                case .pause:
                    return .empty()
                case .reset:
                    return .just(.reset)
                }
            }
            .scan(into: 0) { cumulative, action in
                switch action {
                case .tick:
                    return cumulative += 1
                case .reset:
                    return cumulative = 0
                }
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
