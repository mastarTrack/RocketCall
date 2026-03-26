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
//        let error: PublishSubject<Error>
    }
    
    //MARK: 속성 선언
    let coreDataManager: CoreDataManager
    let disposeBag = DisposeBag()
    
    //MARK: init
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func transform(_ input: Input) -> Output {
        let fetch = input.fetchData
            .share()
        
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
        
        let total: Observable<Result<TotalResult, Error>> = fetch
            .withUnretained(self)
            .flatMap { `self`, _ in
                self.fetchTotalResult()
                    .map {
                        .success($0)
                    }
                    .catch {
                        .just(.failure($0))
                    }
            }
        
        return Output(
            alarm: alarm,
            total: total
        )
    }
}

//MARK: 가장 가까운 알람 가져오기
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
            print(alarms)
            let filtered = alarms.filter {
                $0.isOn == true // 활성화 된 알람
                && ($0.repeatDays.isEmpty || $0.repeatDays.contains(weekday)) // 반복 요일이 없거나, 반복 요일에 현재 요일이 포함된 경우
                && time <= ($0.hour * 60 + $0.minute) // 현재 시간보다 뒤로 설정된 알람만
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
    enum TargetPlanet: Int, CaseIterable {
        case moon = 2 // 시간 기준! 달은 2시간
        case mars = 10 // 10시간
        case venus = 25 // ...
        case mercury = 55
        case sun = 100
        case jupiter = 250
        case saturn = 500
        case uranus = 1000
        case neptune = 2000
        
        var title: String {
            switch self {
            case .moon: "달"
            case .mars: "화성"
            case .venus: "금성"
            case .mercury: "수성"
            case .sun: "태양"
            case .jupiter: "목성"
            case .saturn: "토성"
            case .uranus: "천왕성"
            case .neptune: "해왕성"
            }
        }
    }
    
    struct TotalResult {
        var complete: Int // 누적 완료 미션 횟수
        var totalTime: Int // 누적 집중 시간 (분)
        var streak: Int // 미션 연속 성공 일수
        var target: TargetPlanet? // 다음 목표 행성
        
        var weeklyResult: [Int: Int] // 주간 기록
    }
    
    private func fetchTotalResult() -> Observable<TotalResult> {
        Observable.create { [weak self] observer in
            guard let self else { return Disposables.create() }
            do {
                let results = try self.coreDataManager.fetchAllMissionResult()
                
                if results.isEmpty {
                    let total = TotalResult(complete: 0, totalTime: 0, streak: 0, target: TargetPlanet.moon, weeklyResult: [:])
                    observer.onNext(total)
                    observer.onCompleted()
                } else {
                    let calculation = calculateTotal(of: results)
                    let targetPlanet = TargetPlanet.allCases.filter { ($0.rawValue * 60) >= calculation.totalTime }.first
                    
                    let weeklyResult = calculateWeeklyTotal(of: results)
                    
                    let total = TotalResult(
                        complete: calculation.complete,
                        totalTime: calculation.totalTime,
                        streak: calculation.streak,
                        target: targetPlanet,
                        weeklyResult: weeklyResult
                    )
                    
                    observer.onNext(total)
                    observer.onCompleted()
                }
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    // 총 집중 시간, 성공 미션 횟수, 연속 기록 일수를 계산하는 메서드
    private func calculateTotal(of results: [MissionResultPayload]) -> (complete: Int, totalTime: Int, streak: Int) {
        let calendar = Calendar.current
        
        let sortedByStartDate = results.sorted(by: { $0.start > $1.start }) // 미션 결과 start 날짜 기준 최근순 정렬
        
        let result = sortedByStartDate.reduce(into: (complete: 0, totalTime: 0, streak: 0, benchmark: Date.now)) {
            guard $1.isCompleted else { return } // 성공 미션일 경우에만 코드 진행
            
            if $0.streak >= 0 // 연속 기록이 유효하고
                && $1.start >= calendar.startOfDay(for: $0.benchmark) // result의 시작 시간이 기준일 범위 내에 있을 경우
                && $1.start <= calendar.startOfDay(for: $0.benchmark + 86399) {
                
                $0 = (
                    $0.complete + 1,
                    $0.totalTime + $1.studyTime,
                    $0.streak + 1,
                    $1.start
                )
            } else {
                // 연속 기록이 유효하지 않을 경우 (streak == -1)
                // 혹은 result의 시작 시간이 기준일 범위 밖에 있을 경우 (== 연속 기록이 아닌 경우)
                $0 = (
                    $0.complete + 1,
                    $0.totalTime + $1.studyTime,
                    -1,
                    $0.benchmark
                )
            }
        }
        
        return (result.complete, result.totalTime, result.streak)
    }
    
    // 주간 누적 기록을 계산하는 메서드
    private func calculateWeeklyTotal(of results: [MissionResultPayload]) -> [Int: Int] {
        let calendar = Calendar.current
        let date = Date.now
        let todayWeekday = calendar.dateComponents(in: .current, from: date).weekday ?? -1
        
        let start = calendar.startOfDay(for: date).advanced(by: TimeInterval(-86400 * (todayWeekday - 2))) // 월요일 00:00
        let end = calendar.startOfDay(for: date).addingTimeInterval(TimeInterval(86400 * (9 - todayWeekday)) - 1) // 일요일 23:59
        
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
