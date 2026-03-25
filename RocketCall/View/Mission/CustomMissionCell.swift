//
//  CustomMissionCell.swift
//  RocketCall
//
//  Created by 손영빈 on 3/25/26.
//

import UIKit
import SnapKit

class CustomMissionCell: UICollectionViewCell {
    
    static let id = "CustomMissionCell"
    
    private let containerView = BaseCardView()
    
    private let labelStackView = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let cycleLabel = UILabel()
    
    private let rightStackView = UIStackView()
    private let timeLabel = UILabel()
    private let startButton = CircleButton(size: 50, backgroundColor: .mainPoint, image: UIImage(systemName: "play"), tintColor: .white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttributes()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomMissionCell {
    private func setAttributes() {
        let titleConfig = LabelConfiguration.title
        let subtitleConfig = LabelConfiguration.subTitle
        
        labelStackView.axis = .vertical
        labelStackView.spacing = 5
        
        titleLabel.font = LabelConfiguration.descriptionTitle.font
        titleLabel.textColor = titleConfig.color
        
        subtitleLabel.font = subtitleConfig.font
        subtitleLabel.textColor = subtitleConfig.color
        
        cycleLabel.font = subtitleConfig.font
        cycleLabel.textColor = subtitleConfig.color
        
        timeLabel.font = titleConfig.font
        timeLabel.textColor = titleConfig.color
        
        rightStackView.axis = .vertical
        rightStackView.spacing = 5
        rightStackView.alignment = .trailing
        
    }
    
    private func setLayout() {
        contentView.addSubview(containerView)
        [titleLabel,subtitleLabel,cycleLabel].forEach { labelStackView.addArrangedSubview($0) }
        [timeLabel,startButton].forEach { rightStackView.addArrangedSubview($0) }
        [labelStackView,rightStackView].forEach { containerView.addSubview($0) }
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        labelStackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(rightStackView.snp.leading)
        }
        
        rightStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.bottom.equalToSuperview().inset(20)
        }
    }
}

extension CustomMissionCell {
    func config(title: String, subtitle: String, cycle: String, time: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        cycleLabel.text = cycle
        timeLabel.text = time
    }
}

