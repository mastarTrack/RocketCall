//
//  StateRowView.swift
//  RocketCall
//
//  Created by Yeseul Jang on 3/24/26.
//
import UIKit
import SnapKit
import Then

// MissionResultView 구성을 위한 뷰
final class StateRowView: InfoPairView {
    
    private let stateLabel = StateLabel(text: "✓ 성공", config: .success)
    
    init(title: String) {
        super.init(title: title, dataLabel: stateLabel)
        updateState(true) // 기본값
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateState(_ isSuccess: Bool) {
        let text = isSuccess ? "✓ 성공" : "✗ 실패"
        let config: StateLabelConfiguration = isSuccess ? .success : .failure
        
        apply(text: text, config: config)
    }
    
    private func apply(text: String, config: StateLabelConfiguration) {
        stateLabel.text = text
        stateLabel.font = config.font
        stateLabel.textColor = config.color
        stateLabel.backgroundColor = config.backgroundColor
        
        stateLabel.invalidateIntrinsicContentSize()
        stateLabel.setNeedsLayout()
        stateLabel.layoutIfNeeded()
    }
}
