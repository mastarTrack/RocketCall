//
//  circleContainerView.swift
//  RocketCall
//
//  Created by Yeseul Jang on 3/23/26.
//
import UIKit
import SnapKit

final class CircleContainerView: UIView {
    
    private let circleSize: CGFloat
    
    init(size: CGFloat, color: UIColor = .mainPoint) {
        self.circleSize = size
        super.init(frame: .zero)
        configureUI(color: color)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(color: UIColor) {
        backgroundColor = color
        layer.cornerRadius = circleSize / 2
        clipsToBounds = true
    }
    
    private func setupLayout() {
        self.snp.makeConstraints {
            $0.size.equalTo(circleSize)
        }
    }
}
