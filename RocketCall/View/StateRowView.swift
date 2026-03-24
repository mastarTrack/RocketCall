//
//  StateRowView.swift
//  RocketCall
//
//  Created by Yeseul Jang on 3/24/26.
//
import UIKit
import SnapKit
import Then

// 실패시 로직 고민해보기
final class StateRowView: InfoPairView {
    init(title: String) {
        let stateLabel = StateLabel(text: "✓ 성공", config: .success)
        super.init(title: title, dataLabel: stateLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
