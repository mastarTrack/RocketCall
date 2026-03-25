//
//  ActivatedMissionCell.swift
//  RocketCall
//
//  Created by 손영빈 on 3/25/26.
//

import UIKit
import SnapKit

class ActivatedMissionCell: UICollectionViewCell {
    
    static let id = "ActivatedMissionCell"
    
    
    private let containerView = BaseCardView()
    
    private let stateLabel = StateLabel(text: "1/4 사이클", config: .complete) //수정 필요
    private let titleLabel = UILabel()
    private let timeLabel = UILabel()
    
//    나중에 추가
//    private let progressBar = UIProgressView()
    
    private let buttonStackView = UIStackView()
    private let startButton = RectangleButton(title: "발사",image: UIImage(systemName: "play"), backgroundColor: .cardBackground, tintColor: .mainPoint) // 색상 수정 필요
    private let resetButton = RectangleButton(image: UIImage(systemName: "arrow.trianglehead.counterclockwise.rotate.90"), backgroundColor: .cardBackground, tintColor: .mainLabel) // 색상 수정 필요
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttributes()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ActivatedMissionCell {
    private func setAttributes() {
        let titleConfig = LabelConfiguration.title
        let timeConfig = LabelConfiguration.missionTime
        
        titleLabel.font = titleConfig.font
        titleLabel.textColor = titleConfig.color
        
        timeLabel.font = timeConfig.font
        timeLabel.textColor = timeConfig.color
        
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 10
        
        var startConfig = startButton.configuration
        startConfig?.background.strokeColor = .mainPoint
        startConfig?.background.strokeWidth = 1
        startButton.configuration = startConfig
        
        var resetConfig = resetButton.configuration
        resetConfig?.background.strokeColor = .white
        resetConfig?.background.strokeWidth = 1
        resetButton.configuration = resetConfig
        
    }
    private func setLayout() {
        contentView.addSubview(containerView)
        
        [startButton, resetButton].forEach { buttonStackView.addArrangedSubview($0) }
        [stateLabel, titleLabel, timeLabel, buttonStackView].forEach { containerView.addSubview($0) }
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stateLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(stateLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(20)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        startButton.snp.makeConstraints {
            $0.width.equalTo(resetButton).multipliedBy(5)
            $0.height.equalTo(resetButton.snp.height)
        }
        resetButton.snp.makeConstraints {
            $0.height.equalTo(resetButton.snp.width)
        }
        
    }
}

// 나중에 모델로 통합
extension ActivatedMissionCell {
    func config(cycleText: String, title: String, time: String) {
        stateLabel.text = cycleText
        titleLabel.text = title
        timeLabel.text = time
    }
}
