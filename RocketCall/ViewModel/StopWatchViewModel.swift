//
//  StopWatchViewModel.swift
//  RocketCall
//
//  Created by Hanjuheon on 3/25/26.
//

import Foundation
import RxSwift
import RxRelay

// DiffableDataSource용 레코드 구조체
struct RecordData: Hashable {
    var count : Int
    var time : String
    var location : String
    var isLive : Bool
}

/// StopWatch ViewModel
class StopWatchViewModel {
    
    /// 스탑워치 상태
    enum State {
        /// 스탑워치 동작
        case run
        /// 스탑워치 일시정지
        case pause
        /// 스탑워치 초기화
        case reset
    }
    
    /// 스탑워치 동작액션
    enum timerAction {
        /// 시간 동작 액션
        case tick
        /// 시간 초기화 액션
        case reset
        /// 레코드 생성 액션
        case record
    }
    
    /// 스탑워치 데이터 구조체
    struct StopWatchData {
        /// 스탑워치 메인 타이머
        var mainTimer = 0
        /// 스탑워치 레코드 타이머
        var recordTimer = 0
        /// 스탑워치 레코드 정보 배열
        var records: [RecordData] = []
    }
    /// View -> ViewModel Action
    struct Input {
        /// 스탑워치 동작 In
        let stopwatchAction: Observable<State>
        /// 레코드 In
        let record: Observable<Void>
    }
    
    /// ViewModel -> View  Action
    struct Output {
        /// 메인타이머 Out
        let mainTimer: Observable<String>
        /// 레코드 정보 Out
        let record: Observable<[RecordData]>
    }
    
    /// 변환 메소드
    func transform(_ input: Input) -> Output {
        
        // 스톱워치 동작 액션(timerAction)으로 변환
        let timeAction = input.stopwatchAction
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
        
        // 레코드 액션 반환
        let recordAction = input.record
            .map { timerAction.record }
        
        // 액션에 따른 스탑워치 동작액션 처리
        let state = Observable.merge(timeAction, recordAction)
            .scan(StopWatchData()) { [weak self] data, action in
                guard let self else { return StopWatchData() }
                var newData = data
                
                switch action {
                case .tick:
                    // 전체 타이머와 레코드 타이머를 모두 1 증가
                    newData.mainTimer = newData.mainTimer + 1
                    newData.recordTimer = newData.recordTimer + 1
                case .record:
                    // 현재 recordTimer 값을 확정 레코드로 저장
                    let recordData = RecordData(count: newData.records.count + 1,
                                                time: formatTime(newData.recordTimer),
                                                location: "",
                                                isLive: false)
                    newData.recordTimer = 0
                    newData.records.insert(recordData, at: 0)
                case .reset:
                    // 스탑워치 전체 정보 초기화
                    newData.mainTimer = 0
                    newData.recordTimer = 0
                    newData.records.removeAll()
                }
                return newData
            }
            // 초기값 설정
            .startWith(StopWatchData())
            // 공유 설정
            .share(replay: 1)
        
        // 메인타이머에 대한 문자열 변환 처리 및 출력 데이터 생성
        let mainTimer = state
            .map { [weak self] data in
                guard let self else { return "" }
                return formatTime(data.mainTimer)
            }
        
        // 실시간 레코드 정보 및 과거 데이터 통합 출력용 데이터 생성
        let record = state
            .map { [weak self] data -> [RecordData] in
                guard let self else { return [] }
                let currentRecord = RecordData(count: data.records.count + 1,
                                               time: formatTime(data.recordTimer),
                                               location: "",
                                               isLive: true)
                
                return [currentRecord] + data.records
            }
        
        
        return Output(
            mainTimer: mainTimer,
            record: record
        )
    }
    
    
    /// 밀리초 포멧팅 메소드
    private func formatTime(_ centiseconds: Int) -> String {
        let minutes = centiseconds / 6000
        let seconds = (centiseconds % 6000) / 100
        let cs = centiseconds % 100
        
        return String(format: "%02d:%02d.%02d", minutes, seconds, cs)
    }
}



