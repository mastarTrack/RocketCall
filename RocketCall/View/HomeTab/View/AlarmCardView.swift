//
//  AlarmCard.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/24/26.
//
import UIKit
import SnapKit
import Then

class AlarmCardView: BaseCardView {
    //MARK: set Attributes
    // - 알람 존재 시
    let colorChip = UIView().then {
        $0.backgroundColor = .subPoint
        $0.clipsToBounds = true
    }
    
    let repeatDaysLabel = UILabel().then {
        $0.textColor = .subLabel
        $0.font = .systemFont(ofSize: 12, weight: .medium)
    }
    
    private lazy var repeatDaysStackView = SymbolLabelStack(symbol: "calendar", symbolColor: .subPoint, label: repeatDaysLabel)
    
    let titleLabel = UILabel().then {
        $0.textColor = .mainLabel
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
    }
    
    let bar = UIView().then {
        $0.backgroundColor = UIColor(red: 201/255.0, green: 209/255.0, blue: 232/255.0, alpha: 0.3) // cardView border와 동일
        $0.snp.makeConstraints {
            $0.height.equalTo(1)
        }
    }
    
    let timeTitle = UILabel().then {
        $0.textColor = .subLabel
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.text = "알람 시간"
    }
    
    let timeLabel = UILabel().then {
        $0.textColor = .mainLabel
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    // - 알람이 없을 시
    let emptyAlarmImage = UIImageView().then {
        let config = UIImage.SymbolConfiguration(weight: .medium)
        $0.image = UIImage(systemName: "bell.slash", withConfiguration: config)
        $0.tintColor = .subPoint.withAlphaComponent(0.4)
        $0.isHidden = true
        
        $0.setContentHuggingPriority(UILayoutPriority(249), for: .vertical)
        $0.snp.makeConstraints {
            $0.width.height.equalTo(40)
        }
    }
    
    let emptyAlarmLabel = UILabel(text: "활성화 된 알람이 없습니다", config: LabelConfiguration.sub14).then {
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setLayout()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AlarmCardView {
    func setLayout() {
        
        addSubview(colorChip)
        addSubview(repeatDaysStackView)
        addSubview(titleLabel)
        addSubview(bar)
        addSubview(timeTitle)
        addSubview(timeLabel)
        
        colorChip.snp.makeConstraints {
            $0.leading.verticalEdges.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.02)
        }
        
        repeatDaysStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalTo(colorChip.snp.trailing).offset(10)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(repeatDaysStackView.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.leading.equalTo(colorChip.snp.trailing).offset(10)
        }
        
        bar.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(colorChip.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(10)
        }
        
        timeTitle.snp.makeConstraints {
            $0.top.equalTo(bar.snp.bottom).offset(12)
            $0.leading.equalTo(colorChip.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(10)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(timeTitle.snp.bottom).offset(5)
            $0.leading.equalTo(colorChip.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().offset(-15)
        }
        
        addSubview(emptyAlarmImage)
        addSubview(emptyAlarmLabel)
        
        emptyAlarmImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.centerX.equalToSuperview()
        }
        
        emptyAlarmLabel.snp.makeConstraints {
            $0.top.equalTo(emptyAlarmImage.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-30)
        }
    }
    
    func toggleIsHidden() {
        repeatDaysStackView.isHidden.toggle()
        titleLabel.isHidden.toggle()
        bar.isHidden.toggle()
        timeTitle.isHidden.toggle()
        timeLabel.isHidden.toggle()
        
        emptyAlarmImage.isHidden.toggle()
        emptyAlarmLabel.isHidden.toggle()
    }

    func configure(alarm: Alarm) {
        repeatDaysLabel.text = alarm.repeatDays.map { $0.koreanName }.joined(separator: " ")
        titleLabel.text = alarm.title
        timeLabel.text = "\(alarm.hour):\(alarm.minute)"
    }
}
