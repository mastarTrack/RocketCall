//
//  AlarmListViewModel.swift
//  RocketCall
//
//  Created by 김주희 on 3/25/26.
//

import RxSwift
import RxCocoa
import Foundation

final class AlarmListViewModel: ViewModelProtocol {
    
    private let coreDataManager: CoreDataManager
    private let disposeBag = DisposeBag()
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    
    // MARK: - Input
    struct Input {
        let viewWillAppear: Observable<Void>
        let refreshTrigger: Observable<Void>
        let deleteAlarm: Observable<Alarm>
        let addTapped: Observable<Void>
        let itemSelected: Observable<Alarm>
        let toggleAlarm: Observable<(UUID, Bool)>
    }
    
    
    // MARK: - Output
    struct Output {
        let alarms: Driver<[Alarm]>
        let showSettingModal: Driver<AlarmPayload?>
    }
    
    
    // MARK: - transform
    func transform(_ input: Input) -> Output {
        // 알람 데이터 담을 주머니
        let alarmsRelay = BehaviorRelay<[Alarm]>(value: [])
        
        // 새로고침
        let fetchTrigger = PublishRelay<Void>()
        fetchTrigger
            .bind(with: self) { owner, _ in
                owner.fetchAlarms(into: alarmsRelay)
            }
            .disposed(by: disposeBag)
        
        
        // 데이터 불러오기 (처음 켜질 때 + 새로고침할 때)
        Observable.merge(input.viewWillAppear, input.refreshTrigger)
            .bind(to: fetchTrigger)
            .disposed(by: disposeBag)
        
        
        // 스와이프 삭제 로직
        input.deleteAlarm
            .bind(with: self) { owner, alarm in
                do {
                    try owner.coreDataManager.deleteAlarmEntity(of: alarm.id) // 코어데이터 delete
                    
                    NotificationManager.shared.cancelAlarm(alarm.id) // 알람 예약도 삭제
                    fetchTrigger.accept(()) // 삭제 후 리스트 다시 불러오기
                } catch {
                    print("삭제 실패: \(error)")
                }
            }
            .disposed(by: disposeBag)
        
        
        // 모달 띄우기
        let showAdd = input.addTapped.map { _ -> AlarmPayload? in nil } // 알람 새로 추가
        let showEdit = input.itemSelected.map { alarm -> AlarmPayload? in // 기존 알람 수정
            return AlarmPayload(
                id: alarm.id,
                title: alarm.title,
                hour: alarm.hour,
                minute: alarm.minute,
                isRepeat: !alarm.repeatDays.isEmpty,
                repeatDays: alarm.repeatDays.map { $0.rawValue },
                isOn: alarm.isOn
            )
        }
        let showModal = Observable.merge(showAdd, showEdit).asDriver(onErrorDriveWith: .empty())
        
        
        // 토글 상태 업데이트
        input.toggleAlarm
            .bind(with:self) { owner, data in
                let (id, isOn) = data
                do {
                    // 코어데이터 원본 가져오기
                    let originalPayload = try owner.coreDataManager.fetchAlarm(of: id)
                    
                    // isOn만 갈아끼운 새로운 Payload 생성하기
                    var updatedPayload = originalPayload
                    updatedPayload.isOn = isOn
                    
                    // 코어데이터 업데이트
                    try owner.coreDataManager.updateAlarmEntity(of: updatedPayload)
                    
                    // 알람 예약용 데이터
                    let toggleAlarm = Alarm(
                        id: updatedPayload.id,
                        hour: updatedPayload.hour,
                        minute: updatedPayload.minute,
                        title: updatedPayload.title,
                        repeatDays: updatedPayload.repeatDays.compactMap { WeekDay(rawValue: $0) },
                        isOn: updatedPayload.isOn)
                    
                    // 켜면 예약하기
                    if isOn {
                        NotificationManager.shared.addAlarm(toggleAlarm)
                    } else {
                        // 끄면 취소하기
                        NotificationManager.shared.cancelAlarm(toggleAlarm.id)
                    }
                    
                    // 리스트 다시 불러오기
                    fetchTrigger.accept(())
                    
                } catch {
                    print("토글 DB 저장 실패: \(error)")
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            alarms: alarmsRelay.asDriver(), // 최신 알람 리스트
            showSettingModal: showModal     // 모달 띄우기
        )
    }
    
    
    // 코어데이터에서 불러와서 변환하는 함수 (Payload -> Alarm)
    private func fetchAlarms(into relay: BehaviorRelay<[Alarm]>) {
        do {
            let payloads = try coreDataManager.fetchAllAlarm()
            let alarms = payloads.map { payload in
                Alarm(id: payload.id,
                      hour: payload.hour,
                      minute: payload.minute,
                      title: payload.title,
                      repeatDays: payload.repeatDays.compactMap { WeekDay(rawValue: $0) },
                      isOn: payload.isOn
                )
            }
            relay.accept(alarms)
        } catch {
            print("불러오기 실패: \(error)")
        }
    }
}

