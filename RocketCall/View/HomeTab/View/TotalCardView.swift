//
//  SmallCardView.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/25/26.
//

import UIKit
import SnapKit
import Then

class TotalCardView: BaseCardView {
    //MARK: Category Enum
    enum CardCategory: Int, Hashable {
        case totalTime = 0
        case leftTime
        case totalCount
        case streak
        
        var title: String {
            switch self {
            case .totalTime: "총 시간"
            case .leftTime: "남은 항행 시간"
            case .totalCount: "미션"
            case .streak: "연속 기록"
            }
        }
        
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
    private var type: CardCategory = .totalTime
    private let symbolConfig = UIImage.SymbolConfiguration(scale: .small)
    
    private lazy var symbol = UIImageView().then {
        $0.image = UIImage(systemName: type.symbol, withConfiguration: symbolConfig)
        $0.tintColor = type.titleColor
    }
    
    private lazy var title = UILabel().then {
        $0.text = type.title
        $0.textColor = type.titleColor
        $0.font = .systemFont(ofSize: 12, weight: .semibold)
    }
    
    private let valueLabel = UILabel(text: "", config: .homeViewHeader)
    private let detailLabel = UILabel(text: "", config: .subTitle)
    
    convenience init(type: CardCategory) {
        self.init(frame: .zero)
        
        backgroundColor = type.color.withAlphaComponent(0.2)
        layer.borderColor = type.color.withAlphaComponent(0.3).cgColor
        
        setLayout(type: type)
    }
}

extension TotalCardView {
    private func setLayout(type: CardCategory) {
//        let titleStackView = SymbolLabelStack(symbol: type.symbol, symbolColor: type.titleColor, label: title)
        
        let titleStackView = UIStackView(arrangedSubviews: [symbol, title]).then {
            $0.axis = .horizontal
            $0.spacing = 5
            
            symbol.setContentHuggingPriority(.required, for: .horizontal)
            symbol.setContentCompressionResistancePriority(.required, for: .horizontal)
            
            $0.snp.makeConstraints {
                $0.height.equalTo(title.snp.height)
            }
        }
        
        let stackView = UIStackView(arrangedSubviews: [titleStackView, valueLabel, detailLabel]).then {
            $0.axis = .vertical
            $0.spacing = 5
            $0.alignment = .leading
            
            detailLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
            detailLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        }
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(15)
        }
    }
}

extension TotalCardView {
    func configure(_ data: HomeViewModel.SumResult) {
        // 색상 설정
        backgroundColor = data.cardType.color.withAlphaComponent(0.2)
        layer.borderColor = data.cardType.color.withAlphaComponent(0.3).cgColor
        
        title.text = data.cardType.title
        title.textColor = data.cardType.titleColor
        
        symbol.image = UIImage(systemName: data.cardType.symbol, withConfiguration: symbolConfig)
        symbol.tintColor = data.cardType.titleColor
        
        // text 설정
        configureLabelText(data: data)
    }
    
    private func configureLabelText(data: HomeViewModel.SumResult) {
        switch data.cardType {
        case .totalTime, .leftTime:
            valueLabel.text = "\(data.value)시간"
            detailLabel.text = "\(data.detail)분"
            
        case .totalCount:
            valueLabel.text = "\(data.value)회"
            detailLabel.text = "완료"
            
        case .streak:
            valueLabel.text = "\(data.value)일"
            detailLabel.text = "항해 중🚀"
        }
    }
}
