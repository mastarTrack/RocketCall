//
//  TitleView.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/23/26.
//

import UIKit
import SnapKit

class TitleView: UIView {
    let titleLabel: UILabel
    let subTitleLabel: UILabel
    let addButton: UIButton = UIButton(configuration: .plain())
    
    init(title: String, subTitle: String, hasButton: Bool) {
        titleLabel = UILabel(text: title, config: LabelConfiguration.title)
        subTitleLabel = UILabel(text: subTitle, config: LabelConfiguration.subTitle)
        addButton.isHidden = !hasButton
        super.init(frame: .zero)
        
        setAttributes()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TitleView {
    private func setAttributes() {
        backgroundColor = .clear
        
        let symbolConfig = UIImage.SymbolConfiguration(weight: .heavy)
        addButton.setImage(UIImage(systemName: "plus.circle.fill",withConfiguration: symbolConfig), for: .normal)
        addButton.tintColor = .mainPoint
    }
    
    private func setLayout() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .leading
        
        addSubview(stackView)
        addSubview(addButton)
        
        stackView.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(addButton.snp.leading).offset(-10)
        }
        
        addButton.snp.makeConstraints {
            $0.centerY.equalTo(stackView)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(45)
        }
    }
}
