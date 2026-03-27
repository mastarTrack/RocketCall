//
//  SmallCardView.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/25/26.
//

import UIKit
import SnapKit
import Then

class SmallCardView: BaseCardView {
    //MARK: Category Enum
    enum CardCategory: String {
        case totalTime = "총 시간"
        case leftTime = "남은 항행 시간"
        case totalCount = "미션"
        case streak = "연속 기록"
        
        var symbol: String {
            switch self {
            case .totalTime: "chart.bar.fill"
            case .leftTime: "hourglass"
            case .totalCount: "medal"
            case .streak: "bolt"
            }
        }
        
        var color: UIColor {
            switch self {
            case .totalTime:
                return UIColor(red: 0.17, green: 0.50, blue: 1.00, alpha: 1.00) // HEX #2B7FFF
            case .leftTime:
                return UIColor(red: 0.00, green: 0.79, blue: 0.31, alpha: 1.00) // HEX #00C950
            case .totalCount:
                return UIColor(red: 1.00, green: 0.41, blue: 0.00, alpha: 1.00) // HEX #FF6900
            case .streak:
                return UIColor(red: 0.68, green: 0.27, blue: 1.00, alpha: 1.00) // HEX #AD46FF
            }
        }
        
        var titleColor: UIColor {
            switch self {
            case .totalTime:
                return UIColor(red: 0.32, green: 0.64, blue: 1.00, alpha: 1.00) // HEX #51A2FF
            case .leftTime:
                return UIColor(red: 0.02, green: 0.87, blue: 0.45, alpha: 1.00) // HEX #05DF72
            case .totalCount:
                return UIColor(red: 1.00, green: 0.54, blue: 0.02, alpha: 1.00) // HEX #FF8904
            case .streak:
                return UIColor(red: 0.76, green: 0.48, blue: 1.00, alpha: 1.00) // HEX #C27AFF
            }
        }
    }
    
    //MARK: set Attributes
    let valueLabel = UILabel(text: "", config: .homeViewHeader)
    let detailLabel = UILabel(text: "완료", config: .subTitle)
    
    convenience init(type: CardCategory) {
        self.init(frame: .zero)
        
        backgroundColor = type.color.withAlphaComponent(0.2)
        layer.borderColor = type.color.withAlphaComponent(0.3).cgColor
        
        setLayout(type: type)
    }
}

extension SmallCardView {
    private func setLayout(type: CardCategory) {
        let title = UILabel().then {
            $0.text = type.rawValue
            $0.textColor = type.titleColor
            $0.font = .systemFont(ofSize: 12, weight: .semibold)
        }
        
        let titleStackView = SymbolLabelStack(symbol: type.symbol, symbolColor: type.titleColor, label: title)
        
        addSubview(titleStackView)
        addSubview(valueLabel)
        addSubview(detailLabel)
        
        titleStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.horizontalEdges.equalToSuperview().inset(15)
        }
        
        valueLabel.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        detailLabel.snp.makeConstraints {
            $0.top.equalTo(valueLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(15)
        }
    }
}

extension SmallCardView {
    func configure(type: CardCategory, valueText: String, detailText: String) {
        backgroundColor = type.color.withAlphaComponent(0.2)
        layer.borderColor = type.color.withAlphaComponent(0.3).cgColor
        
        valueLabel.text = valueText
        detailLabel.text = detailText
    }
}
