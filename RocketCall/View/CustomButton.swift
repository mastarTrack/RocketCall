//
//  CustomButton.swift
//  RocketCall
//
//  Created by Yeseul Jang on 3/23/26.
//
import UIKit

class CustomButton: UIButton {
    init(title: String, color: UIColor) {
        super.init(frame: .zero)
        setAttributes(title: title, color: color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomButton {
    private func setAttributes(title: String, color: UIColor) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = .boldSystemFont(ofSize: 16)
        self.titleLabel?.textAlignment = .center
        self.backgroundColor = color
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
    }
}
