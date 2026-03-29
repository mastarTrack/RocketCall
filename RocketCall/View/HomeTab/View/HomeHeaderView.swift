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
        $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
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
            $0.top.equalToSuperview().offset(10)
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
