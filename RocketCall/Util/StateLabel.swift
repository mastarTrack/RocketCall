//
//  StateLabel.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/23/26.
//

import UIKit

/// 상태 Label
class StateLabel: UILabel {
    private let padding = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        layer.masksToBounds = true
        textAlignment = .center
    }
    
    convenience init(text: String, config: StateLabelConfiguration) {
        self.init()        
        self.text = text
        self.textColor = config.color // 글자 색
        self.backgroundColor = config.backgroundColor // 배경 색
        
        // 테두리 존재 시
        if let borderColor = config.borderColor {
            self.layer.borderWidth = 1
            self.layer.borderColor = borderColor.cgColor // 테두리 색
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StateLabel {
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    // 고유 크기
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
}
