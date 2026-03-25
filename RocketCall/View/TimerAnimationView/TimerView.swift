//
//  TimerView.swift
//  RocketCall
//
//  Created by Yeseul Jang on 3/25/26.
//

import UIKit
import SnapKit

final class TimerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .black
    }
}
