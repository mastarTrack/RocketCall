//
//  HomeHeaderView.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/29/26.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class HomeHeaderView: UIView {
    private let titleLabel = UILabel(text: "제목", config: LabelConfiguration.homeViewHeader)
    fileprivate let detailButton = UIButton(configuration: .plain()).then {
        $0.backgroundColor = .clear
        $0.tintColor = .mainPoint
        $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
    }
    let unitLabel = UILabel().then {
        $0.text = "(단위: 분)"
        $0.textColor = .subLabel
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, unitLabel, detailButton]).then {
            $0.axis = .horizontal
            $0.spacing = 5
            $0.alignment = .lastBaseline
            
            detailButton.setContentHuggingPriority(.required, for: .horizontal)
            detailButton.setContentCompressionResistancePriority(.required, for: .horizontal)
            unitLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
            unitLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-5)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, hasButton: Bool, buttonTitle: String = "") {
        titleLabel.text = title
        detailButton.isHidden = !hasButton
        detailButton.setTitle(buttonTitle, for: .normal)
    }
}

extension Reactive where Base: HomeHeaderView {
    var detailButtonTap: ControlEvent<Void> {
        base.detailButton.rx.tap
    }
}
