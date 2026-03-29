//
//  StopWatchViewModel.swift
//  RocketCall
//
//  Created by Hanjuheon on 3/25/26.
//

import Foundation
import UIKit
import RxSwift
import RxRelay
import RxCocoa

/// DiffableDataSource용 레코드 구조체
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
    enum TimerAction {
        /// 시간 동작 액션
        case tick
        /// 시간 초기화 액션
        case reset
        /// 레코드 생성 액션
        case record
        /// 동작 유무 액션
        case isRunning(Bool)
        /// 백그라운드 액션
        case background(Date)
        /// 포어그라운드 액션
        case foreground(Date)
    }
    
    /// 스탑워치 데이터 구조체
    struct StopWatchData {
        /// 스탑워치 메인 타이머
        var mainTimer = 0
        /// 스탑워치 레코드 타이머
        var recordTimer = 0
        /// 스탑워치 레코드 정보 배열
        var records: [RecordData] = []
        /// 스탑워치 동작 유무 체크
        var isRun = false
        /// 백그라운드 진입 시간
        var backgroundEnterTime: Date?
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
        /// 현재 위치값 Out
        let location: Observable<String>
        /// 다음 위치값 Out
        let targetLocation: Observable<String>
    }
    
    /// 변환 메소드
    func transform(_ input: Input) -> Output {
        
        // 실행 상태 업데이트 액션
        let runningAction = input.stopwatchAction
            .map { state -> TimerAction in
                switch state {
                case .run:
                    return .isRunning(true)
                case .pause, .reset:
                    return .isRunning(false)
                }
            }
        
        // 스톱워치 동작 액션(timerAction)으로 변환
        let timeAction = input.stopwatchAction
            .flatMapLatest{ state -> Observable<TimerAction> in
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
            .map { TimerAction.record }
        
        // NotificationCenter을 이용하여 앱라이프 사이클을 통해 현재 시간 값을 추출
        // 앱이 활성상태를 잃을때(didEnterBackgroundNotification) 발생 : 홈화면, 전화 및 다른 제어샌터 등으로 이동 시
        let backgroundAction = NotificationCenter.default.rx
            .notification(UIApplication.didEnterBackgroundNotification)
            .map { _ in
                return TimerAction.background(Date())
            }
        
        // 앱이 다시 활성상태가 되었을때(willEnterForegroundNotification) 발생
        let foregroundAction = NotificationCenter.default.rx
            .notification(UIApplication.willEnterForegroundNotification)
            .map { _ in
                return TimerAction.foreground(Date())
            }
        
        
        // 액션에 따른 스탑워치 동작액션 처리
        let state = Observable.merge(timeAction, recordAction, runningAction, backgroundAction, foregroundAction)
            .scan(StopWatchData()) { [weak self] data, action in
                guard let self else { return StopWatchData() }
                var newData = data
                
                switch action {
                // 전체 타이머와 레코드 타이머를 모두 1 증가
                case .tick:
                    newData.mainTimer = newData.mainTimer + 1
                    newData.recordTimer = newData.recordTimer + 1
                
                // 현재 recordTimer 값을 확정 레코드로 저장
                case .record:
                    let recordData = RecordData(count: newData.records.count + 1,
                                                time: formatTime(newData.recordTimer),
                                                location: FreeStage.currentLocationTitle(newData.mainTimer),
                                                isLive: false)
                    newData.recordTimer = 0
                    newData.records.insert(recordData, at: 0)
                
                // 스탑워치 전체 정보 초기화
                case .reset:
                    newData.mainTimer = 0
                    newData.recordTimer = 0
                    newData.records.removeAll()
               
                // 스탑워치 동작 여부 설정
                case .isRunning(let isRunning):
                    newData.isRun = isRunning
                    if !newData.isRun {
                        newData.backgroundEnterTime = nil
                    }
                
                // 백그라운드 액션 시, 해당 시점 저장
                case .background(let BackDate):
                    if newData.isRun{
                        newData.backgroundEnterTime = BackDate
                    }
                
                // 어플리케이션 재 진입 시, 로직
                case .foreground(let foreDate):
                    // 스탑워치 동작여부 체크 및 백그라운드 진입 시간 존재 여부 체크
                    guard newData.isRun,
                          let backgroundDate = newData.backgroundEnterTime else {
                        return newData
                    }

                    // 현재 값 및 백그라운드 저장 값 차이 계싼 및 밀리초로 변환
                    let backgroundTime = foreDate.timeIntervalSince(backgroundDate)
                    let centisecond = Int((backgroundTime * 100).rounded())
                    newData.backgroundEnterTime = nil

                    // 밀리 초 삽입
                    guard centisecond > 0 else { return newData }
                    newData.mainTimer += centisecond
                    newData.recordTimer += centisecond
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
                                               location: FreeStage.currentLocationTitle(data.mainTimer),
                                               isLive: true)
                
                return [currentRecord] + data.records
            }
        
        let location = state
            .map { data -> String in
                return FreeStage.currentLocationTitle(data.mainTimer) + (data.mainTimer != 0 ? " 항행 중" : " 대기 중")
            }
        
        let targetLocation = state
            .map {data -> String in
                return "다음 위치: \(FreeStage.targetLocationTitle(data.mainTimer))"
            }
        
        return Output(
            mainTimer: mainTimer,
            record: record,
            location: location,
            targetLocation: targetLocation
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



enum FreeStage: Int, CaseIterable {
    case launchPad
    case surface
    case troposphere
    case stratosphere
    case mesosphere
    case thermosphere
    case exosphere
    case deepSpace
    case moon
    
    var title: String {
        switch self {
        case .launchPad: "발사대"
        case .surface: "지표면"
        case .troposphere: "대류권"
        case .stratosphere: "성층권"
        case .mesosphere: "중간권"
        case .thermosphere: "열권"
        case .exosphere: "외기권"
        case .deepSpace: "심우주"
        case .moon: "달"
        }
    }
    
    static func currentLocationTitle(_ centiseconds: Int) -> String {
        let elapsedMinutes = Double(centiseconds) / 6000.0
        switch elapsedMinutes {
        case 0:
            return FreeStage.launchPad.title
        case 0.0..<5.0:
            return FreeStage.surface.title
        case 5.0..<13.0:
            return FreeStage.troposphere.title
        case 13.0..<20.0:
            return FreeStage.stratosphere.title
        case 20.0..<35.0:
            return FreeStage.mesosphere.title
        case 35.0..<55.0:
            return FreeStage.thermosphere.title
        case 55.0..<120.0:
            return FreeStage.exosphere.title
        default:
            return FreeStage.deepSpace.title
        }
    }
    
    static func targetLocationTitle(_ centiseconds: Int) -> String {
        let elapsedMinutes = Double(centiseconds) / 6000.0
        
        switch elapsedMinutes {
        case 0:
            return FreeStage.surface.title
        case 0.0..<5.0:
            return FreeStage.troposphere.title
        case 5.0..<13.0:
            return FreeStage.stratosphere.title
        case 13.0..<20.0:
            return FreeStage.mesosphere.title
        case 20.0..<35.0:
            return FreeStage.thermosphere.title
        case 35.0..<55.0:
            return FreeStage.exosphere.title
        case 55.0..<120.0:
            return FreeStage.deepSpace.title
        default:
            return FreeStage.moon.title
        }
    }
}
