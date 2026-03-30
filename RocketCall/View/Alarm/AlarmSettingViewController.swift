//
//  AlarmSettingiewController.swift
//  RocketCall
//
//  Created by 김주희 on 3/23/26.
//

import UIKit
import RxSwift
import RxCocoa


final class AlarmSettingViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let alarmSettingView = AlarmSettingView()
    var viewModel = AlarmSettingViewModel(existingAlarm: nil)
    var onSaveSuccess: (() -> Void)?     // 저장 성공했을때 ListVC로 보낼 클로저
    
    
    override func loadView() {
        view = alarmSettingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        bind()
    }
    
    
    // MARK: - Binding
    private func bind() {
        // 요일 버튼 tag 전달
        let dayToggled = Observable.merge(
            alarmSettingView.dayButtons.map { button in
                button.rx.tap.map { button.tag }
            }
        )
        
        // 취소,닫기 버튼 merge
        let cancelOrClose = Observable.merge(
            alarmSettingView.cancelButton.rx.tap.asObservable(),
            alarmSettingView.closeButton.rx.tap.asObservable()
        )
        
        // MARK: Input
        let input = AlarmSettingViewModel.Input(
            timeSelected: alarmSettingView.timePickerView.rx.date.asObservable(),
            titleText: alarmSettingView.alarmTextField.rx.text.asObservable(),
            dayToggled: dayToggled,
            cancelButtonTapped: cancelOrClose,
            saveButtonTapped: alarmSettingView.saveButton.rx.tap.asObservable()
        )
        
        
        // MARK:  Input -> VM
        let output = viewModel.transform(input)
        
        
        // MARK: VM -> Output
        // 수정모드일때 데이터 불러오기
        output.initialSetup
            .drive(onNext: { [weak self] payload in
                guard let self = self, let payload = payload else { return }
                
                // DatePicker 세팅
                var components = DateComponents()
                components.hour = payload.hour
                components.minute = payload.minute
                if let date = Calendar.current.date(from: components) {
                    self.alarmSettingView.timePickerView.date = date
                }
                
                // 텍스트필드 세팅
                self.alarmSettingView.alarmTextField.text = payload.title
                
                // 요일 버튼 활성화 세팅
                payload.repeatDays.forEach { dayIndex in
                    if dayIndex < self.alarmSettingView.dayButtons.count {
                        self.alarmSettingView.dayButtons[dayIndex].isSelected = true
                    }
                }
            })
            .disposed(by: disposeBag)
        
        // 저장 성공
        output.saveCompleted
            .drive(onNext: { [weak self] in
                self?.onSaveSuccess?()
            })
            .disposed(by: disposeBag)
        
        // 화면 닫기
        output.dismissView
            .drive(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
