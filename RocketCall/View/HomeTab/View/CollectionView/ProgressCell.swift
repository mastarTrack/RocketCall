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
    
    let titleLabel = UILabel().then {
        $0.text = "태양계 정복도"
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .mainLabel
    }
    let subTitleLabel = UILabel(text: "집중할수록 행성에 가까워져요", config: .sub14)
    
    let startPlanet = UILabel().then {
        $0.text = TargetPlanet.earth.emoji
        $0.font = .systemFont(ofSize: 30)
    }
    let targetPlanet = UILabel().then {
        $0.text = TargetPlanet.moon.emoji
        $0.font = .systemFont(ofSize: 30)
    }
    
    let progressView = GradientProgressView()
    let progressLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = .mainLabel
        $0.text = "\(TargetPlanet.earth.title) → \(TargetPlanet.moon.title)"
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
            
            titleLabel.setContentHuggingPriority(.required, for: .vertical)
            titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
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
            $0.top.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(infoButton.snp.leading)
        }
        
        infoButton.snp.makeConstraints {
            $0.bottom.equalTo(titleStack.snp.bottom)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        progressStack.snp.makeConstraints {
            $0.top.equalTo(titleStack.snp.bottom).offset(10)
            $0.bottom.horizontalEdges.equalToSuperview().inset(20)
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
            $0.alignment = .center
            
            barStack.setContentHuggingPriority(.defaultLow, for: .horizontal)
            barStack.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            
            startPlanet.setContentHuggingPriority(.required, for: .horizontal)
            startPlanet.setContentCompressionResistancePriority(.required, for: .horizontal)
            targetPlanet.setContentHuggingPriority(.required, for: .horizontal)
            targetPlanet.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
        
        return progressStack
    }
}

extension ProgressCell {
    func configure(target: TargetPlanet) {
        guard let start = TargetPlanet(rawValue: target.rawValue - 1) else { return }
        
        progressLabel.text = "\(start.title) → \(target.title)"
        
        startPlanet.text = start.emoji
        targetPlanet.text = target.emoji
        
        progressView.setProgress(0.5, animated: true)
    }
}
