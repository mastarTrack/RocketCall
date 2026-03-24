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
    let repeatDaysLabel = UILabel().then {
        $0.textColor = .subLabel
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.text = "월 화 수 목 금"
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        
        setLayout()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AlarmCardView {
    func setLayout() {
        let colorChip = UIView().then {
            $0.backgroundColor = .subPoint
            $0.clipsToBounds = true
        }
     
        let repeatDaysStackView = UIStackView(symbol: "calendar", symbolColor: .subPoint, label: repeatDaysLabel)
        
        addSubview(colorChip)
        addSubview(repeatDaysStackView)
        
        colorChip.snp.makeConstraints {
            $0.leading.verticalEdges.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.02)
        }
        
        repeatDaysStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalTo(colorChip.snp.trailing).offset(10)
        }
        
    }
}
