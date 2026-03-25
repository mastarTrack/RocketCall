//
//  CustomStepper.swift
//  RocketCall
//
//  Created by 손영빈 on 3/25/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CustomStepper: UIView {
    
    private let disposeBag = DisposeBag()
    let value: BehaviorRelay<Int>
    
    private let labelStackView = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private let stepperStackView = UIStackView()
    private let plusButton = CircleButton(size: 30, backgroundColor: .cardBackground, image: UIImage(systemName: "plus"), tintColor: .mainLabel)
    private let minusButton = CircleButton(size: 30, backgroundColor: .cardBackground, image: UIImage(systemName: "minus"), tintColor: .mainLabel)
    private let valueLabel = UILabel()
    
    init(title: String, subtitle: String, initialValue: Int) {
        self.value = BehaviorRelay(value: initialValue)
        super.init(frame: .zero)
        titleLabel.text = title
        subtitleLabel.text = subtitle
        setAttributes()
        setLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomStepper {
    private func bind() {
        value
            .map { "\($0)" }
            .bind(to: valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        value
            .map { $0 > 0 }
            .bind(to: minusButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        value
            .map { $0 < 180 }
            .bind(to: plusButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        plusButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.value.accept(self.value.value + 1)
            }).disposed(by: disposeBag)
        
        minusButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.value.accept(self.value.value - 1)
            }).disposed(by: disposeBag)

    }
}

extension CustomStepper {
    private func setAttributes() {
        
        titleLabel.font = LabelConfiguration.missionLabel.font
        titleLabel.textColor = LabelConfiguration.missionLabel.color
        
        subtitleLabel.font = .systemFont(ofSize: 12)
        subtitleLabel.textColor = .secondLabel
        
        valueLabel.font = LabelConfiguration.main24Bold.font
        valueLabel.textColor = LabelConfiguration.main24Bold.color
        valueLabel.textAlignment = .center
        valueLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        labelStackView.axis = .vertical
        labelStackView.spacing = 4
        labelStackView.alignment = .leading
        
        stepperStackView.axis = .horizontal
        stepperStackView.spacing = 14
        stepperStackView.alignment = .center
    }
    
    private func setLayout() {
        [titleLabel, subtitleLabel].forEach { labelStackView.addArrangedSubview($0) }
        [minusButton, valueLabel, plusButton].forEach { stepperStackView.addArrangedSubview($0) }
        
        addSubview(labelStackView)
        addSubview(stepperStackView)
        
        labelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(10)
            $0.trailing.lessThanOrEqualTo(stepperStackView.snp.leading).offset(-12)
        }
        
        stepperStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(10)
        }
    }
}

