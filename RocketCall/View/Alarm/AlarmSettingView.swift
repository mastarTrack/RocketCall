//
//  presentSettingView.swift
//  RocketCall
//
//  Created by 김주희 on 3/23/26.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa


final class AlarmSettingView: UIView {
        
    
    // MARK: - UI Components
    private let containerView = BaseCardView()
    
    private let titleLabel = UILabel().then {
        $0.text = "알람 설정"
        $0.apply(.title)
    }
    
    let closeButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(weight: .semibold)
        $0.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        $0.tintColor = .mainLabel
    }
    
    private let alarmTimeStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
    }
    
    private let watchImage = UIImageView().then {
        $0.image = UIImage(systemName: "alarm")
        $0.tintColor = .subPoint
    }
    
    private let alarmTimeLabel = UILabel().then {
        $0.text = "알람 시간"
        $0.textColor = .subPoint
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    let timePickerView = UIDatePicker().then {
        $0.datePickerMode = .time
        $0.preferredDatePickerStyle = .wheels
        $0.overrideUserInterfaceStyle = .dark
    }
    
    private let alarmNameTitle = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.text = "알람 이름"
        $0.textColor = .mainLabel
    }
    
    let alarmTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "예: 기상",
            attributes: [.foregroundColor: UIColor.subLabel.withAlphaComponent(0.8)]
            )
        $0.textColor = .mainLabel
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.subLabel.withAlphaComponent(0.6).cgColor
        
        // 왼쪽 여백
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 40))
        $0.leftViewMode = .always
    }
    
    private let repeatDayTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.text = "반복 요일"
        $0.textColor = .mainLabel
    }
    
    private let dayButtonsStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
        $0.spacing = 6
    }
    
    private(set) var dayButtons: [DayButton] = []
    
    private func setupDayButtons() {
        let days = ["월", "화", "수", "목", "금", "토", "일"]
        
        for (index, day) in days.enumerated() {
            let button = DayButton(title: day)
            button.tag = index
            button.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
            
            button.snp.makeConstraints {
                $0.width.equalTo(38)
                $0.height.equalTo(50)
            }
            
            dayButtonsStackView.addArrangedSubview(button)
            dayButtons.append(button)
        }
    }
    
    @objc private func dayButtonTapped(_ sender: DayButton) {
        sender.isSelected.toggle()
    }
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 12
        $0.distribution = .fillEqually
    }
    
    let cancelButton = RectangleButton(title: "취소", color: .subLabel.withAlphaComponent(0.2))
    let saveButton = RectangleButton(title: "저장", color: .mainPoint)

    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupDayButtons()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    
    // MARK: - setup UI
    private func setupUI() {
        containerView.isOn = true
        
        self.addSubview(containerView)
        
        [titleLabel, closeButton, alarmTimeStackView, timePickerView, alarmNameTitle, alarmTextField, repeatDayTitleLabel, dayButtonsStackView, buttonStackView].forEach { containerView.addSubview($0) }
        
        [watchImage, alarmTimeLabel].forEach { alarmTimeStackView.addArrangedSubview($0) }
        
        [cancelButton, saveButton].forEach { buttonStackView.addArrangedSubview($0) }
        
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-40)
            $0.height.equalTo(590)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(25)
            $0.leading.equalToSuperview().inset(25)
        }
        
        closeButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview()
            $0.height.width.equalTo(70)
        }
        
        alarmTimeStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        timePickerView.snp.makeConstraints {
            $0.top.equalTo(alarmTimeStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        alarmNameTitle.snp.makeConstraints {
            $0.top.equalTo(timePickerView.snp.bottom)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        alarmTextField.snp.makeConstraints {
            $0.top.equalTo(alarmNameTitle.snp.bottom).offset(8)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(50)
        }
        
        repeatDayTitleLabel.snp.makeConstraints {
            $0.top.equalTo(alarmTextField.snp.bottom).offset(25)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        dayButtonsStackView.snp.makeConstraints {
            $0.top.equalTo(repeatDayTitleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview().inset(25)
            $0.centerX.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        saveButton.snp.makeConstraints {
            $0.height.equalTo(cancelButton)
        }
    }
}


// 요일버튼 생성기
final class DayButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            updateColors()
        }
    }
    
    init(title: String) {
        super.init(frame: .zero)
        
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        updateColors()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func updateColors() {
        if isSelected {
            setTitleColor(.mainPoint, for: .normal)
            backgroundColor = .mainPoint.withAlphaComponent(0.2)
        } else {
            setTitleColor(.mainLabel, for: .normal)
            backgroundColor = .subLabel.withAlphaComponent(0.2)
        }
    }
}
