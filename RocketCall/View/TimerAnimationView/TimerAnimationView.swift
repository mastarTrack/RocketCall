//
//  TimerAnimationView.swift
//  RocketCall
//
//  Created by Yeseul Jang on 3/25/26.
//
import UIKit
import SnapKit
import Then

final class TimerAnimationView: UIView {
    private let backgroundImageView = UIImageView().then {
        $0.image = UIImage(named: "backGroundImage")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .background
        
        addSubview(backgroundImageView)
        sendSubviewToBack(backgroundImageView)
    }
    
    private func setupLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
