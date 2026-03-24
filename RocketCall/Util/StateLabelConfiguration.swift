//
//  StateLabelConfiguration.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/23/26.
//

import UIKit

struct StateLabelConfiguration {
    let font: UIFont // 폰트
    let color: UIColor // 글자 색상
    let backgroundColor: UIColor // 배경 색상
    let borderColor: UIColor? // 테두리 색상
    
    init(font: UIFont, color: UIColor, backgroundColor: UIColor = UIColor.cardBackground, borderColor: UIColor? = nil) {
        self.font = font
        self.color = color
        
        self.borderColor = borderColor
        self.backgroundColor = backgroundColor
    }
}

extension StateLabelConfiguration {
    // 예시
    static let complete = StateLabelConfiguration(
        font: .systemFont(ofSize: 14, weight: .medium),
        color: .systemGreen,
        backgroundColor: UIColor(red: 0.88, green: 1.00, blue: 0.91, alpha: 1.00),
        borderColor: UIColor.red
    )
}

extension StateLabelConfiguration {
    static let success = StateLabelConfiguration(
        font: .systemFont(ofSize: 14, weight: .medium),
        color: .systemGreen,
        backgroundColor: UIColor.systemGreen.withAlphaComponent(0.2)
    )
}
