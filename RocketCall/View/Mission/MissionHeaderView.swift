//
//  MissionHeaderView.swift
//  RocketCall
//
//  Created by 손영빈 on 3/25/26.
//

import UIKit
import SnapKit

class MissionHeaderView: UICollectionReusableView {
    static let id = "MissionHeaderView"
    
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttributes()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MissionHeaderView {
    private func setAttributes() {
        let config = LabelConfiguration.subTitle
        titleLabel.font = config.font
        titleLabel.textColor = config.color
    }
    
    private func setLayout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension MissionHeaderView {
    func config(title: String) {
        titleLabel.text = title
    }
}
