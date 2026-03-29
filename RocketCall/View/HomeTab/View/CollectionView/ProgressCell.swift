//
//  ProgressCell.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/27/26.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class ProgressCell: UICollectionViewCell {
    private let cardView = BaseCardView().then {
        $0.isOn = true
        $0.backgroundColor = .mainPoint.withAlphaComponent(0.2)
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "태양계 정복도"
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .mainLabel
    }
    private let subTitleLabel = UILabel(text: "집중할수록 행성에 가까워져요", config: .sub14)
    
    private let startPlanet = UILabel().then {
        $0.text = Planet.earth.emoji
        $0.font = .systemFont(ofSize: 30)
    }
    private let targetPlanet = UILabel().then {
        $0.text = Planet.moon.emoji
        $0.font = .systemFont(ofSize: 30)
    }
    
    private let progressView = GradientProgressView()
    private let progressLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = .mainLabel
        $0.text = "\(Planet.earth.title) → \(Planet.moon.title)"
    }
    private let targetTimeLabel = UILabel(text: "시간", config: .sub12).then {
        $0.textAlignment = .right
    }
    
    fileprivate let infoButton = CircleButton(
        size: 45,
        backgroundColor: .clear,
        image: UIImage(systemName: "info.circle"),
        tintColor: .subLabel
    )
    
    private(set) var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
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
    func configure(status: HomeViewModel.ProgressStatus) {
        progressLabel.text = "\(status.current.title) → \(status.target?.title ?? "")"
        targetTimeLabel.text = "\(status.target?.targetTime ?? 0)시간"
        
        startPlanet.text = status.current.emoji
        targetPlanet.text = status.target?.emoji
        
        progressView.setProgress(status.progress, animated: true)
    }
}

extension Reactive where Base :ProgressCell {
    var infoButtonTap: ControlEvent<Void> {
        base.infoButton.rx.tap
    }
}
