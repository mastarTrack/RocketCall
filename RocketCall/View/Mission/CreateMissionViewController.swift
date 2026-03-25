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
        )
        
        let output = viewModel.transform(input: input)
        
        output.totalTime
            .bind(to: mainView.totalTimeValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.intervalText
            .bind(to: mainView.intervalValueLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
