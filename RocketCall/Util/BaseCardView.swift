//
//  BaseCardView.swift
//  RocketCall
//
//  Created by 김주희 on 3/23/26.
//

// let cardView = BaseCardView()
// cardView.isOn = true -> border 색상 보라색으로 변경
// 기본값: off (회색)


import UIKit

class BaseCardView: UIView {
    
    var isOn: Bool = false {
        didSet {
            let activeColor = UIColor(red: 108/255.0, green: 92/255.0, blue: 231/255.0, alpha: 0.8).cgColor
            let inactiveColor = UIColor(red: 201/255.0, green: 209/255.0, blue: 232/255.0, alpha: 0.3).cgColor
            
            self.layer.borderColor = isOn ? activeColor : inactiveColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupStyle() {
        self.backgroundColor = UIColor(red: 18/255.0, green: 26/255.0, blue: 48/255.0, alpha: 1.0)
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 201/255.0, green: 209/255.0, blue: 232/255.0, alpha: 0.3).cgColor
    }
}
