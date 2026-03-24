//
//  UIStackView+.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/24/26.
//

import UIKit

// symbol label 가로 스택뷰 생성용
extension UIStackView {
    convenience init(symbol: String, symbolColor: UIColor, label: UILabel) {
        self.init()
        
        let symbol = UIImageView(image: UIImage(systemName: symbol))
        symbol.tintColor = symbolColor
        
//        NSLayoutConstraint.activate([
//            symbol.widthAnchor.constraint(equalTo: heightAnchor)
//        ])
        
        addArrangedSubview(symbol)
        addArrangedSubview(label)
        
        axis = .horizontal
        spacing = 5
    }
}
