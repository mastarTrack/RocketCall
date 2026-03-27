//
//  AlarmSettingViewModel.swift
//  RocketCall
//
//  Created by 김주희 on 3/25/26.
//

import RxSwift
import RxCocoa
import Foundation

final class AlarmSettingViewModel: ViewModelProtocol {
    
    private let coreDataManager = CoreDataManager()
    private let disposeBag = DisposeBag()
    private let existingAlarm: AlarmPayload?
    
    init(existingAlarm: AlarmPayload?) {
        self.existingAlarm = existingAlarm
    }
    
    
    // MARK: - Input
    struct Input {
        let timeSelected: Observable<Date>
        let titleText: Observable<String?>
        let dayToggled: Observable<Int>
        let cancelButtonTapped: Observable<Void>
        let saveButtonTapped: Observable<Void>
    }
    
    
    // MARK: - Output
    struct Output {
        let initialSetup: Driver<AlarmPayload?> // 화면 켤 때 기존 데이터 불러오기
        let dismissView: Driver<Void>   // 화면 닫기
        let saveCompleted: Driver<Void>
    }
    
    
    // MARK: - transform
    func transform(_ input: Input) -> Output {
                
        // MARK: 스트림
        // 시간 스트림 (Date -> 시, 분)
        
        // 기존 알람 있으면 그 시간으로, 없으면 현 시간
        let initialHour = existingAlarm?.hour ?? Calendar.current.component(.hour, from: Date())
        let initialMinute = existingAlarm?.minute ?? Calendar.current.component(.minute, from: Date())
        
        let timeStream = input.timeSelected
            .skip(1)    // 현재시간 무시
            .map { date -> (Int, Int) in
                let calendar = Calendar.current
                return (calendar.component(.hour, from: date), calendar.component(.minute, from: date))
            }
            .startWith((initialHour, initialMinute))
                
        // 타이틀 스트림
        let initialTitle = existingAlarm?.title ?? ""

        let titleStream = input.titleText
            .skip(1)
            .map { $0 ?? "" }
            .startWith(initialTitle)
        
        // 요일 스트림
        let initialDays = Set<Int>(existingAlarm?.repeatDays ?? [])
        let daysStream = input.dayToggled
            .scan(initialDays) { currentDays, toggledDay in
                var newDays = currentDays
                if newDays.contains(toggledDay) {
                    newDays.remove(toggledDay)
                } else {
                    newDays.insert(toggledDay)
                }
                return newDays
            }
            .startWith(initialDays)
        
        
        // MARK: 저장 버튼 클릭 시 -> 위의 3개 스트림의 최신값 모아서 전송하기
        let saveSuccess = PublishRelay<Void>()
        
        input.saveButtonTapped
            .withLatestFrom(Observable.combineLatest(timeStream, titleStream, daysStream)) // 가장 최근 값들 가져오기
            .bind(with: self) { owner, data in
                let (time, title, days) = data // 묶여온 데이터 풀기
                let (hour, minute) = time
                let isRepeat = !days.isEmpty
                let finalTitle = title.isEmpty ? "알람" : title
                
                // payload로 포장
                let payload = AlarmPayload(
                    id: owner.existingAlarm?.id ?? UUID(),
                    title: finalTitle,
                    hour: hour,
                    minute: minute,
                    isRepeat: isRepeat,
                    repeatDays: Array(days).sorted(),
                    isOn: true // 저장하면 무조건 on
                )
                
                // 알람 에약에 쓸 모델
                let alarmForNoti = Alarm(
                    id: payload.id,
                    hour: payload.hour,
                    minute: payload.minute,
                    title: payload.title,
                    repeatDays: payload.repeatDays.compactMap { WeekDay(rawValue: $0) },
                    isOn: payload.isOn
                )
                
                // 코어데이터 저장 및 알람 예약
                do {
                    if let oldPayload = owner.existingAlarm {
                        try owner.coreDataManager.updateAlarmEntity(of: payload)
                        
                        // 기존 알람 예약 취소
                        let oldAlarm = Alarm(id: oldPayload.id, hour: oldPayload.hour, minute: oldPayload.minute, title: oldPayload.title, repeatDays: oldPayload.repeatDays.compactMap { WeekDay(rawValue: $0) }, isOn: oldPayload.isOn
                        )
                        NotificationManager.shared.cancelAlarm(oldAlarm.id)
                    } else {
                        try owner.coreDataManager.createAlarmEntity(alarm: payload)
                    }
                    
                    // 알람 예약하기
                    NotificationManager.shared.addAlarm(alarmForNoti)

                    saveSuccess.accept(()) // 성공 트리거 발사
                } catch {
                    print("저장 실패: \(error)")
                }
            }
            .disposed(by: disposeBag)
        
        
        // 화면 닫기 트리기
        let dismissView = Observable.merge(saveSuccess.asObservable(), input.cancelButtonTapped)
            .asDriver(onErrorDriveWith: .empty())
        
        return Output(
            initialSetup: Driver.just(existingAlarm),
            dismissView: dismissView,
            saveCompleted: saveSuccess.asDriver(onErrorDriveWith: .empty())
        )
    }
}
