//
//  TimerAnimationBottomView.swift
//  RocketCall
//
//  Created by Yeseul Jang on 3/25/26.
//

import UIKit
import SnapKit
import Then

final class TimerAnimationBottomView: UIView {

    let missionTitleLabel = UILabel(config:.sub16).then {
        $0.text = "타이머 이름"
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    let timerLabel = UILabel().then {
        $0.text = "24:57"
        $0.numberOfLines = 1
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 50, weight: .bold)
    }
    
    let cycleLabel = UILabel().then {
        $0.text = "1 / 4 사이클"
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = UIColor.subLabel.withAlphaComponent(0.9)
    }
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 18
        $0.alignment = .center
    }
    
    let backButton = CircleButton(
        size: 40,
        backgroundColor: UIColor.white.withAlphaComponent(0.3),
        image: UIImage(systemName: "chevron.left"),
        tintColor: .white
    )
    
    let stopButton = CircleButton(
        size: 60,
        backgroundColor: .mainPoint,
        image: UIImage(systemName: "pause.fill"),
        tintColor: .white
    )
    
    let missionStopButton = CircleButton(
        size: 40,
        backgroundColor: UIColor.white.withAlphaComponent(0.3),
        image: UIImage(systemName: "stop"),
        tintColor: .white
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(missionTitle: String, timerText: String, cycleText: String) {
        missionTitleLabel.text = missionTitle
        timerLabel.text = timerText
        cycleLabel.text = cycleText
    }
    
    private func configureUI() {
        backgroundColor = .black
        
        buttonStackView.addArrangedSubview(backButton)
        buttonStackView.addArrangedSubview(stopButton)
        buttonStackView.addArrangedSubview(missionStopButton)
        
        addSubview(missionTitleLabel)
        addSubview(timerLabel)
        addSubview(cycleLabel)
        addSubview(buttonStackView)
    }
    
    private func setupLayout() {
        
        missionTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        }
        
        timerLabel.snp.makeConstraints {
            $0.top.equalTo(missionTitleLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        
        cycleLabel.snp.makeConstraints {
            $0.top.equalTo(timerLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(cycleLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
}
