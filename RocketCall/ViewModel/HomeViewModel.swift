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
        let fetchData: PublishRelay<Void>
    }
    
    struct Output {
        let alarm: Observable<Result<Alarm?, Error>>
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
        
        return Output(
            alarm: alarm
        )
    }
}

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
                    observer.on(.next(nil))
                    observer.onCompleted()
                }
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    private func fetchNearestAlarmPayload() throws -> AlarmPayload? {
        let calendar = Calendar.current
        let dateComp = calendar.dateComponents(in: .current, from: Date.now) // 현재 날짜의 dateComponents
        
        guard let weekday = dateComp.weekday,
              let hour = dateComp.hour,
              let minute = dateComp.minute else { return nil }
        
        let time = hour * 60 + minute
        
        do {
            let alarms = try coreDataManager.fetchAllAlarm()
            
            let filtered = alarms.filter {
                $0.isOn == true // 활성화 된 알람
                && ($0.repeatDays.isEmpty || $0.repeatDays.contains(weekday)) // 반복 요일이 없거나, 반복 요일에 현재 요일이 포함된 경우 - repeatDays Set타입이 낫나?
                && time <= ($0.hour * 60 + $0.minute) // 현재 시간보다 뒤로 설정된 알람만
            }
            
            return filtered.first

        } catch {
            throw error
        }
    }
}
