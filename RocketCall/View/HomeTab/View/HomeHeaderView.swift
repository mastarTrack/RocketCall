//
//  HomeHeaderView.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/29/26.
//

import UIKit
import SnapKit
import Then

final class HomeHeaderView: UIView {
    private let titleLabel = UILabel(text: "제목", config: LabelConfiguration.homeViewHeader)
    private let detailButton = UIButton(configuration: .plain()).then {
        $0.backgroundColor = .clear
        $0.tintColor = .mainPoint
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, detailButton]).then {
            $0.axis = .horizontal
            $0.spacing = 5
            $0.alignment = .bottom
            
            detailButton.setContentHuggingPriority(.required, for: .horizontal)
            detailButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, hasButton: Bool) {
        titleLabel.text = title
        detailButton.isHidden = !hasButton
    }
}
