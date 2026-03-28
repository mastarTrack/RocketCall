//
//  HomeViewModel.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/26/26.
//

import RxSwift
import RxCocoa
import Foundation

final class HomeViewModel: ViewModelProtocol {
    struct Input {
        let fetchData: Observable<Void>
    }
    
    struct Output {
        let alarm: Observable<Result<Alarm?, Error>> // (alarm: 알람, isExist: 존재 여부)
        let total: Observable<Result<TotalResult, Error>>
        let sum: Observable<Result<[SumResult], Error>> // 미션 결과 통계
        let missionResults: Observable<Result<[MissionResultPayload], Error>>
    }
    
    //MARK: 속성 선언
    let coreDataManager: CoreDataManager
    let disposeBag = DisposeBag()
    private(set) var weeklyData: WeeklyData // ChartView 바인딩용
    
    struct TotalResultValue {
        let value: String
        let detail: String
    }
    
    //MARK: init
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        self.weeklyData = WeeklyData()
    }
    
    func transform(_ input: Input) -> Output {
        let fetch = input.fetchData
            .share()
        
        // 가까운 알람
        let alarm: Observable<Result<Alarm?, Error>> = fetch
            .withUnretained(self)
            .flatMap { `self`, _ in
                self.fetchNearestAlarm()
                    .map {
                        .success($0)
                    }
                    .catch {
                        .just(.failure($0))
                    }
            }
        
        // 미션 결과 통계
//        let total: Observable<Result<TotalResult, Error>> = fetch
//            .withUnretained(self)
//            .flatMap { `self`, _ in
//                self.fetchTotalResult()
//                    .map {
//                        .success($0)
//                    }
//                    .catch {
//                        .just(.failure($0))
//                    }
//            }
//            .share()
        
        // 주간 기록 차트뷰와 바인딩
        total.subscribe(onNext: { [weak self] result in
            if case .success(let total) = result {
                self?.weeklyData.newValue(total.weeklyRawData) // 차트뷰에서 사용하는 주간 기록 업데이트
            }
        })
        .disposed(by: disposeBag)
        
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
        
        
        return Output(
            alarm: alarm,
            total: total,
            missionResults: missionResults
        )
    }
}

extension HomeViewModel {
    struct SumResult {
        var cardType: TotalCardView.CardCategory
        var value: Int
        var detail: Int?
    }
}

//MARK: 가장 가까운 알람 가져오기 - 로직 수정 필요!
extension HomeViewModel {
    private func fetchNearestAlarm() -> Observable<Alarm?> {
        Observable.create { [weak self] observer in
            do {
                let payload = try self?.fetchNearestAlarmPayload()
                
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
            return Disposables.create()
        }
    }
    
    //TODO: 로직 바꿔야함!!!
    private func fetchNearestAlarmPayload() throws -> AlarmPayload? {
        let calendar = Calendar.current
        let dateComp = calendar.dateComponents(in: .current, from: Date.now) // 현재 날짜의 dateComponents
        
        guard let weekday = dateComp.weekday,
              let hour = dateComp.hour,
              let minute = dateComp.minute else { return nil }
        
        let time = hour * 60 + minute
        
        do {
            let alarms = try coreDataManager.fetchAllAlarm()
//            print(alarms)
            let filtered = alarms.filter {
                $0.isOn == true // 활성화 된 알람
                && ($0.repeatDays.isEmpty || $0.repeatDays.contains(weekday)) // 반복 요일이 없거나, 반복 요일에 현재 요일이 포함된 경우
//                && time <= ($0.hour * 60 + $0.minute)  현재 시간보다 뒤로 설정된 알람만
            }
            print(filtered)
            return filtered.first
            
        } catch {
            throw error
        }
    }
    
    private func time(hour: Int, minute: Int) {
        let calendar = Calendar.current
        let dateComp = calendar.dateComponents(in: .current, from: Date.now)
        
        guard let todayHour = dateComp.hour,
              let todayMinute = dateComp.minute else { return }
        
        if (todayHour * 60 + todayMinute) < (hour * 60 + minute) { // (동일 날짜의 경우) 현재 시간이 알람 시간보다 빠를 때
            
        }
        
//        calendar.date(from: dateComp) - calendar.date(from:)
    }
}

//MARK: Total 기록
extension HomeViewModel {    
    struct TotalResult {
        var complete: Int // 누적 완료 미션 횟수
        var totalTime: Int // 누적 집중 시간 (분)
        var streak: Int // 미션 연속 성공 일수
        var target: TargetPlanet? // 다음 목표 행성
        
        var weeklyRawData: [Int: Int] // 주간 기록 rawdata
    }
    
//    private func fetchTotalResult() -> Observable<TotalResult> {
//        Observable.create { [weak self] observer in
//            guard let self else { return Disposables.create() }
//            do {
//                let results = try self.coreDataManager.fetchAllMissionResult()
//                
//                if results.isEmpty {
//                    let total = TotalResult(complete: 0, totalTime: 0, streak: 0, target: TargetPlanet.moon,
//                                            weeklyRawData: [:]
//                    )
//                    observer.onNext(total)
//                    observer.onCompleted()
//                } else {
//                    let calculation = calculateTotal(of: results)
//                    let targetPlanet = TargetPlanet.allCases.filter { ($0.targetTime * 60) >= calculation.totalTime }.first
//                    let rawData = calculateWeeklyTotal(of: results)
//                    
//                    let total = TotalResult(
//                        complete: calculation.complete,
//                        totalTime: calculation.totalTime,
//                        streak: calculation.streak,
//                        target: targetPlanet,
//                        weeklyRawData: rawData
//                    )
//                    
//                    observer.onNext(total)
//                    observer.onCompleted()
//                }
//            } catch {
//                observer.onError(error)
//            }
//            return Disposables.create()
//        }
//    }
    
    // 총 집중 시간, 성공 미션 횟수, 연속 기록 일수를 계산하는 메서드
//    private func calculateTotal(of results: [MissionResultPayload]) -> (complete: Int, totalTime: Int, streak: Int) {
//        let calendar = Calendar.current
//        
//        let sortedByStartDate = results.sorted(by: { $0.start > $1.start }) // 미션 결과 start 날짜 기준 최근순 정렬
//        
//        let result = sortedByStartDate.reduce(into: (complete: 0, totalTime: 0, streak: 0, benchmark: Date.now)) {
//            guard $1.isCompleted else { return } // 성공 미션일 경우에만 코드 진행
//            
//            if $0.streak >= 0 // 연속 기록이 유효하고
//                && $1.start >= calendar.startOfDay(for: $0.benchmark) // result의 시작 시간이 기준일 범위 내에 있을 경우
//                && $1.start <= calendar.startOfDay(for: $0.benchmark + 86399) {
//                
//                $0 = (
//                    $0.complete + 1,
//                    $0.totalTime + $1.studyTime,
//                    $0.streak + 1,
//                    $1.start
//                )
//            } else {
//                // 연속 기록이 유효하지 않을 경우 (streak == -1)
//                // 혹은 result의 시작 시간이 기준일 범위 밖에 있을 경우 (== 연속 기록이 아닌 경우)
//                $0 = (
//                    $0.complete + 1,
//                    $0.totalTime + $1.studyTime,
//                    -1,
//                    $0.benchmark
//                )
//            }
//        }
//        
//        return (result.complete, result.totalTime, result.streak)
//    }
    
    // 미션 결과 통계 계산 메서드
    private func sumResults(of result: Result<[MissionResultPayload], Error>) -> Observable<Result<[SumResult], Error>> {
        Observable.create { [weak self] observer in
            guard let self else { return Disposables.create() }
            
            switch result {
            case .success(let results):
                let totalTime = self.totalTimeResult(from: results) // 총 집중 시간
                let leftTime = self.leftTimeResult(from: totalTime.detail ?? 0) // 다음 목표까지 남은 시간
                let totalCount = self.completeCountResult(from: results) // 총 미션 성공 횟수
                let streak = self.streakResult(from: results)
                
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
    private func totalTimeResult(from results: [MissionResultPayload]) -> SumResult {
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
    private func leftTimeResult(from totalMinute: Int) -> SumResult {
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
    private func completeCountResult(from results: [MissionResultPayload]) -> SumResult {
            let count = results.filter { $0.isCompleted }.count
            
            return SumResult(
                cardType: .totalCount,
                value: count,
                detail: nil
            )
    }
    
    // 연속 기록 일수 계산 메서드
    private func streakResult(from results: [MissionResultPayload]) -> SumResult {
        // 미션 결과가 없을 경우
        guard !results.isEmpty else {
            return SumResult(
                cardType: .streak,
                value: 0
            )
        }
        
        // 미션 결과가 1개일 경우
        if results.count == 1 {
            return SumResult(
                cardType: .streak,
                value: 1
            )
        }
        
        let calendar = Calendar.current
        
        // 성공 미션 시작일자 배열
        var completed = results
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
            value: streak
        )
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
        
            weeklyRecord[weekday, default: 0] += result.studyTime
        }
        
        return weeklyRecord
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
    
    private func findTargetPlanet(from totalMinute: Int) -> TargetPlanet? {
        TargetPlanet.allCases.filter {
            totalMinute < ($0.targetTime * 60)
        }.first
    }
}
