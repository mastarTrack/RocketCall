//
//  CreateMissionViewController.swift
//  RocketCall
//
//  Created by 손영빈 on 3/25/26.
//

import UIKit
import RxSwift
import RxCocoa

class CreateMissionViewController: UIViewController {
    
    private let mainView = CreateMissionView()
    private let disposeBag = DisposeBag()
    private let viewModel: CreateMissionViewModel
    
    init(viewModel: CreateMissionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}

extension CreateMissionViewController {
    private func bind() {
        let input = CreateMissionViewModel.Input(
            missionName: mainView.missionNameField.rx.text.orEmpty.asObservable(),
            studyTime: mainView.studyStepper.value.asObservable(),
            restTime: mainView.restStepper.value.asObservable(),
            cycleCount: mainView.cycleStepper.value.asObservable(),
            quickItemSelected: mainView.quickItemTapped.asObservable(),
            createButtonTapped: mainView.createButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        output.totalTime
            .bind(to: mainView.totalTimeValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.intervalText
            .bind(to: mainView.intervalValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.selectedQuickItem
            .bind(onNext: { [weak self] index in
                self?.mainView.updateQuickItem(selectedIndex: index)
            })
            .disposed(by: disposeBag)
        
        output.quickStudyTime
            .bind(onNext: { [weak self] studyTime in
                self?.mainView.studyStepper.value.accept(studyTime)
            })
            .disposed(by: disposeBag)
        
        output.quickRestTime
            .bind(onNext: { [weak self] restTime in
                self?.mainView.restStepper.value.accept(restTime)
            })
            .disposed(by: disposeBag)
        
        output.isCreateButtonEnabled
            .bind(to: mainView.createButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.success
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        //TODO: Alert 연결 필요 -> Error 메시지 정의 필요
        output.error
            .subscribe(onNext: { [weak self] error in
                self?.showErrorAlert(message: "오류 발생 ")
            })
            .disposed(by: disposeBag)
    }
}

extension CreateMissionViewController {
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
