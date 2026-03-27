//
//  ProgressCell.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/27/26.
//

import UIKit
import SnapKit
import Then

final class ProgressCell: UICollectionViewCell {
    let cardView = BaseCardView()
    
    let titleLabel = UILabel(text: "태양계 정복도", config: .sub14).then {
        $0.textColor = .mainLabel
    }
    let subTitleLabel = UILabel(text: "집중할수록 행성에 가까워져요", config: .sub12)
    
    let startPlanet = UIImageView()
    let targetPlanet = UIImageView()
    
    let progressView = GradientProgressView()
    let progressLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = .mainLabel
        $0.text = "지구 → 달"
    }
    let targetTimeLabel = UILabel(text: "시간", config: .sub12).then {
        $0.textAlignment = .right
    }
    
    let infoButton = CircleButton(
        size: 45,
        backgroundColor: .clear,
        image: UIImage(systemName: "info.circle"),
        tintColor: .subLabel
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProgressCell {
    private func setLayout() {
        let titleStack = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel]).then {
            $0.axis = .vertical
            $0.spacing = 5
        }
        let progressStack = generateProgressStackView()
        
        contentView.addSubview(cardView)
        
        cardView.addSubview(titleStack)
        cardView.addSubview(infoButton)
        cardView.addSubview(progressStack)
        
        cardView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleStack.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(10)
        }
        
        infoButton.snp.makeConstraints {
            $0.bottom.equalTo(titleStack.snp.bottom)
            $0.trailing.equalToSuperview().inset(10)
        }
        
        progressStack.snp.makeConstraints {
            $0.top.equalTo(titleStack.snp.bottom).offset(10)
            $0.bottom.horizontalEdges.equalToSuperview().inset(10)
        }
    }
    
    private func generateProgressStackView() -> UIStackView {
        let labelStack = UIStackView(arrangedSubviews: [progressLabel, targetTimeLabel]).then {
            $0.axis = .horizontal
            
            targetTimeLabel.setContentHuggingPriority(.required, for: .horizontal)
            targetTimeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
        
        let barStack = UIStackView(arrangedSubviews: [labelStack, progressView]).then {
            $0.axis = .vertical
            $0.spacing = 5
            
            progressView.setContentHuggingPriority(.required, for: .vertical)
            progressView.setContentCompressionResistancePriority(.required, for: .vertical)
        }
        
        let progressStack = UIStackView(arrangedSubviews: [startPlanet, barStack, targetPlanet]).then {
            $0.axis = .horizontal
            $0.spacing = 10
            
            barStack.setContentHuggingPriority(.defaultLow, for: .horizontal)
            barStack.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
        
        return progressStack
    }
}

extension ProgressCell {
    func configure(target: TargetPlanet) {
        
    }
}
