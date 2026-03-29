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
    // 미션페이로드 넘기기 위해 추가함
    private let onMissionCreated: ((MissionPayload) -> Void)?
    
    init(viewModel: CreateMissionViewModel, onMissionCreated: ((MissionPayload) -> Void)? = nil) {
        self.viewModel = viewModel
        self.onMissionCreated = onMissionCreated
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
        
        let isQuickSelected = output.selectedQuickItem
            .map { $0 != nil }
            .share()
        
        isQuickSelected
            .bind(to: mainView.studyStepper.isQuickSelected)
            .disposed(by: disposeBag)
        
        isQuickSelected
            .bind(to: mainView.restStepper.isQuickSelected)
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
        
        //mission 값까지 같이 보내줌
        output.createdMission
            .subscribe(onNext: { [weak self] mission in
                guard let self else { return }
                self.navigationController?.popViewController(animated: false)
                self.onMissionCreated?(mission)
            })
            .disposed(by: disposeBag)
        
        output.error
            .subscribe(onNext: { [weak self] error in
                guard let self else { return }
                self.showErrorAlert(error: error)
            })
            .disposed(by: disposeBag)
    }
}

extension CreateMissionViewController {
    
    private func showErrorAlert(error: CoreDataManager.CoreDataError) {
        let message: String
        switch error {
        case .descriptionLoadFailed:
            message = "데이터 모델을 불러오는 데 실패했습니다."
        case .saveFailed:
            message = "데이터를 저장하는데 실패했습니다."
        case .loadFailed:
            message = "데이터를 불러오는 데 실패했습니다."
        case .empty:
            message = "데이터가 없습니다."
        }
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
