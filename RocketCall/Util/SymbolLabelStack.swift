//
//  UIStackView+.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/24/26.
//

import UIKit
import SnapKit

// symbol label 가로 스택뷰 생성용
class SymbolLabelStack: UIStackView {

    init(symbol: String, symbolColor: UIColor, label: UILabel) {
        super.init(frame: .zero)
        
        let config = UIImage.SymbolConfiguration(scale: .small)
        let symbol = UIImageView(image: UIImage(systemName: symbol, withConfiguration: config))
        
        symbol.tintColor = symbolColor
        
        addArrangedSubview(symbol)
        addArrangedSubview(label)
        
        axis = .horizontal
        spacing = 5
        
        symbol.setContentHuggingPriority(.required, for: .horizontal)
        symbol.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        self.snp.makeConstraints {
            $0.height.equalTo(label.snp.height)
        }
    }
    
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
