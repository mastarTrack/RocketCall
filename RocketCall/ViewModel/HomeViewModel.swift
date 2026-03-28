//
//  HomeViewModel.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/26/26.
//

import RxSwift
import RxCocoa
import Foundation
import UserNotifications

final class HomeViewModel: ViewModelProtocol {
    struct Input {
        let fetchData: Observable<Void>
    }
    
    struct Output {
        let alarm: Observable<Result<Alarm?, Error>> // (alarm: 알람, isExist: 존재 여부)
        let missionResults: Observable<Result<[MissionResultPayload], Error>> // 미션 결과 목록
        let sum: Observable<Result<[SumResult], Error>> // 미션 결과 통계
        let chartRawData: Observable<Result<[Int: Int], Error>> // 차트뷰 업데이트를 위한 dataSource
        let progressStatus: Observable<Result<ProgressStatus, Error>> // ProgressView 데이터
    }
        
    
    //MARK: 속성 선언
    let coreDataManager: CoreDataManager
    let notificationManager: NotificationManager
    let disposeBag = DisposeBag()
    let center = UNUserNotificationCenter.current()
    private(set) var weeklyData: WeeklyData // ChartView 바인딩용
    
    struct TotalResultValue {
        let value: String
        let detail: String
    }
    
    //MARK: init
    init(coreDataManager: CoreDataManager, notificationManager: NotificationManager) {
        self.coreDataManager = coreDataManager
        self.notificationManager = notificationManager
        self.weeklyData = WeeklyData()
    }
    
    func transform(_ input: Input) -> Output {
        let fetch = input.fetchData
            .share()
        
        // 가까운 알람        
        let alarm: Observable<Result<Alarm?, Error>> = fetch
            .withUnretained(self)
            .flatMap { `self`, _ in
                self.nearestAlarm()
                    .map {
                        .success($0)
                    }
                    .catch {
                        .just(.failure($0))
                    }
            }
        
        // 전체 미션 결과 가져오기
        let missionResults: Observable<Result<[MissionResultPayload], Error>> = fetch
            .withUnretained(self)
            .flatMap { `self`, _ in
                self.fetchAllMissionResults()
                    .map {
                        .success($0)
                    }
                    .catch {
                        .just(.failure($0))
                    }
            }
            .share()
        
        // 결과 통계
        let sum: Observable<Result<[SumResult], Error>> = missionResults
            .withUnretained(self)
            .flatMap { `self`, results in
                self.sumResults(of: results)
            }
            .share()
        
        // 상세화면 차트 뷰에 바인딩용 주간 누적 기록 데이터
        let chartRawData = missionResults
            .withUnretained(self)
            .flatMap { `self`, results in
                self.chartRawData(from: results)
            }
        
        let progress: Observable<Result<ProgressStatus, Error>> = sum
            .withUnretained(self)
            .flatMap { `self`, results in
                self.progressStatus(from: results)
            }
        
        return Output(
            alarm: alarm,
            missionResults: missionResults,
            sum: sum,
            chartRawData: chartRawData,
            progressStatus: progress
        )
    }
}

extension HomeViewModel {
    struct SumResult: Hashable {
        var cardType: TotalCardView.CardCategory
        var value: Int
        var detail: Int
    }
}

//MARK: 가장 가까운 알람 가져오기
extension HomeViewModel {
    func nearestAlarm() -> Observable<Alarm?> {
        Observable.create { [weak self] observer in
            let task = Task {
                do {
                    let payload = try await self?.fetchNearestAlarmPayload()
                    
                    if let payload {
                        let result = Alarm(
                            id: payload.id,
                            hour: payload.hour,
                            minute: payload.minute,
                            title: payload.title,
                            repeatDays: payload.repeatDays.compactMap { WeekDay(rawValue: $0) },
                            isOn: payload.isOn
                        )
                        
                        observer.on(.next(result))
                        observer.onCompleted()
                    } else {
                        observer.onNext(nil)
                        observer.onCompleted()
                    }
                } catch {
                    observer.onError(error)
                }
            }
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    private func fetchNearestAlarmPayload() async throws -> AlarmPayload? {
        guard let id = await notificationManager.fetchNearestAlarm() else {
            return nil
        }
        
        do {
            let result = try coreDataManager.fetchAlarm(of: id)
            return result
        } catch {
            throw error
        }
    }
}

//MARK: Total 기록
extension HomeViewModel {
    // 미션 결과 통계 계산 메서드
    private func sumResults(of result: Result<[MissionResultPayload], Error>) -> Observable<Result<[SumResult], Error>> {
        Observable.create { [weak self] observer in
            guard let self else { return Disposables.create() }
            
            switch result {
            case .success(let results):
                let totalTime = self.calculateTotalTime(of: results) // 총 집중 시간
                let leftTime = self.calculateLeftTime(from: totalTime.detail) // 다음 목표까지 남은 시간
                let totalCount = self.calculateCompleteCount(of: results) // 총 미션 성공 횟수
                let streak = self.calculateStreak(of: results)
                
                observer.onNext(.success([totalTime, leftTime, totalCount, streak]))
                observer.onCompleted()
                
            case .failure(let error):
                observer.onNext(.failure(error))
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    // 총 집중 시간 계산 메서드
    private func calculateTotalTime(of results: [MissionResultPayload]) -> SumResult {
        guard !results.isEmpty else {
            return SumResult(
                cardType: .totalTime,
                value: 0,
                detail: 0
            )
        }
        
        let completed = results.filter { $0.isCompleted }
        let seconds = completed.reduce(0) { $0 + $1.studyTime } // 초 단위 - $1.studyTime은 초 단위로 작성
        
        let minutes = seconds / 60 // 분 단위 변환
        let hours = minutes / 60 // 시 단위 변환
        
        return SumResult(
            cardType: .totalTime,
            value: hours,
            detail: minutes
        )
    }
    
    // 다음 목표까지 잔여 시간 계산 메서드
    private func calculateLeftTime(from totalMinute: Int) -> SumResult {
        guard let target = findTargetPlanet(from: totalMinute) else {
            return SumResult(
                cardType: .leftTime,
                value: 0,
                detail: 0
            )
        }
        
        let leftMinute = target.targetTime * 60 - totalMinute // 분 단위 - target.targetTime은 시 단위로 작성
        let leftHour = leftMinute / 60 // 시 단위 변환
        
        return SumResult(
            cardType: .leftTime,
            value: leftHour,
            detail: leftMinute
        )
    }
    
    // 총 성공 미션 횟수 계산 메서드
    private func calculateCompleteCount(of results: [MissionResultPayload]) -> SumResult {
        let count = results.filter { $0.isCompleted }.count
        
        return SumResult(
            cardType: .totalCount,
            value: count,
            detail: -1
        )
    }
    
    // 연속 기록 일수 계산 메서드
    private func calculateStreak(of results: [MissionResultPayload]) -> SumResult {
        // 미션 결과가 없을 경우
        guard !results.isEmpty else {
            return SumResult(
                cardType: .streak,
                value: 0,
                detail: -1
            )
        }
        
        // 미션 결과가 1개일 경우
        if results.count == 1 {
            return SumResult(
                cardType: .streak,
                value: 1,
                detail: -1
            )
        }
        
        let calendar = Calendar.current
        
        // 성공 미션 시작일자 배열
        let completed = results
            .filter { $0.isCompleted }
            .map {
                calendar.startOfDay(for: $0.start)
            }
        
        // 미션 성공 날짜 Set - 최근순 정렬
        let completeDates = Set(completed)
            .sorted(by: { $0 > $1 })
        
        // 어제 날짜
        let yesterday = calendar.date(
            byAdding: .day,
            value: 1,
            to: calendar.startOfDay(for: Date.now)
        )!
        
        
        var streak = 0
        
        /*
         미션 성공 날짜에 어제 날짜가 포함되어있는지 확인
         - 연속 집중 후 접속 일자와 마지막 집중 일자 간격이 1일보다 많은 경우 연속 기록을 초기화하기 위함
         - 예시) 월, 화, 수 연속으로 집중하고 목, 금은 집중하지 않은 상태로 토요일에 접속했을 경우, 기존 연속 기록 3일이 보이지 않도록 하기 위함
         */
        if completeDates.contains(yesterday) {
            for i in 1...completeDates.count {
                let pre = i - 1
                
                if completeDates[i].distance(to: completeDates[pre]) == -86400 {
                    streak += 1
                } else {
                    break
                }
            }
        }
        
        return SumResult(
            cardType: .streak,
            value: streak,
            detail: -1
        )
    }
}

//MARK: Chart RawData
extension HomeViewModel {
    // 차트뷰에 사용할 rawData를 업데이트하고, rawData를 전달하는 메서드
    private func chartRawData(from result: Result<[MissionResultPayload], Error>) -> Observable<Result<[Int: Int], Error>> {
        Observable.create { [weak self] observer in
            guard let self else { return Disposables.create() }
            
            switch result {
            case .success(let results):
                let data = calculateWeeklyTotal(of: results)
                self.weeklyData.newValue(data) // 차트뷰(Main 화면) dataSource 업데이트
                
                observer.onNext(.success(data))
                observer.onCompleted()
                
            case .failure(let error):
                observer.onNext(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    // 주간 누적 기록을 계산하는 메서드
    private func calculateWeeklyTotal(of results: [MissionResultPayload]) -> [Int: Int] {
        let calendar = Calendar.current
        let date = Date.now
        let todayWeekday = calendar.dateComponents(in: .current, from: date).weekday ?? -1
        
        let distanceToMonday = (todayWeekday - 2 + 7) % 7 // 오늘 요일에서 월요일까지의 차이, 월요일의 weekday는 1
        
        let start = calendar.date(byAdding: .day, value: -distanceToMonday, to: calendar.startOfDay(for: date))! // 월요일 00:00
        let end = calendar.date(byAdding: .day, value: 7, to: start.addingTimeInterval(-1))! // 일요일 23:59
        
        let filtered = results.filter {
            $0.isCompleted == true
            && $0.start >= start
            && $0.end <= end
        }
        
        var weeklyRecord: [Int: Int] = [:]
        
        for result in filtered {
            let rawWeekday = calendar.dateComponents(in: .current, from: result.start).weekday ?? -1
            let weekday = rawWeekday == 1 ? 6 : rawWeekday - 2
        
            weeklyRecord[weekday, default: 0] += (result.studyTime / 60)
        }
        
        return weeklyRecord
    }
}

//MARK: Progress View
extension HomeViewModel {
    struct ProgressStatus: Hashable {
        let current: Planet
        let target: Planet?
        let progress: Float
    }
    
    private func progressStatus(from result: Result<[SumResult], Error>) -> Observable<Result<ProgressStatus, Error>> {
        Observable.create { [weak self] observer in
            guard let self else { return Disposables.create() }
            
            switch result {
            case .success(let result):
                let cum = result[TotalCardView.CardCategory.totalTime.rawValue].value // 누적 집중 시간(분)
                let left = result[TotalCardView.CardCategory.leftTime.rawValue].value // 다음 목적지까지 남은 시간(분)
                
                let progressStatus = self.calculateProgress(cum: cum, left: left)
                
                observer.onNext(.success(progressStatus))
                observer.onCompleted()
                
            case .failure(let error):
                observer.onNext(.failure(error))
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    private func calculateProgress(cum: Int, left: Int) -> ProgressStatus {
        let target = findTargetPlanet(from: cum) // 목적지
        
        guard let target else { // 마지막 목적지까지 이미 도달한 경우
            return ProgressStatus(
                current: Planet.allCases.last!,
                target: nil,
                progress: 1
            )
        }
        
        let current = Planet.allCases[target.rawValue - 1]
        let progress = Float(cum) / Float(target.targetTime * 60)
        
        return ProgressStatus(
            current: current,
            target: target,
            progress: progress
        )
    }
}

extension HomeViewModel {
    private func fetchAllMissionResults() -> Observable<[MissionResultPayload]> {
        Observable.create { [weak self] observer in
            guard let self else { return Disposables.create() }
            do {
                let results = try self.coreDataManager.fetchAllMissionResult()
                observer.onNext(results)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    private func findTargetPlanet(from totalMinute: Int) -> Planet? {
        Planet.allCases.filter {
            totalMinute < ($0.targetTime * 60)
        }.first
    }
}
