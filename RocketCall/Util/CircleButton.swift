//
//  Untitled.swift
//  RocketCall
//
//  Created by Yeseul Jang on 3/23/26.
//
import UIKit
import SnapKit

/*
 사용시
 let startButton = CircleButton(
     size: 72,
     backgroundColor: .mainPoint,
     image: UIImage(systemName: "play.fill"),
     tintColor: .white
 )
 */


final class CircleButton: UIButton {
    
    private let buttonSize: CGFloat
    
    init(
        size: CGFloat = 56,
        backgroundColor: UIColor = .mainPoint,
        image: UIImage? = nil,
        tintColor: UIColor = .white
    ) {
        self.buttonSize = size
        super.init(frame: .zero)
        
        configureUI(
            backgroundColor: backgroundColor,
            image: image,
            tintColor: tintColor
        )
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(
        backgroundColor: UIColor,
        image: UIImage?,
        tintColor: UIColor
    ) {
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        
        setImage(image, for: .normal)
        imageView?.contentMode = .scaleAspectFit
        
        layer.cornerRadius = buttonSize / 2
        clipsToBounds = true
    }
    
    private func configureLayout() {
        snp.makeConstraints {
            $0.width.height.equalTo(buttonSize)
        }
    }
}
