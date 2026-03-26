//
//  CustomMissionCell.swift
//  RocketCall
//
//  Created by 손영빈 on 3/25/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CustomMissionCell: UICollectionViewCell {
    
    static let id = "CustomMissionCell"
    
    var disposeBag = DisposeBag()
    
    private let containerView = BaseCardView()
    
    private let labelStackView = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let cycleLabel = UILabel()
    
    private let rightStackView = UIStackView()
    private let timeLabel = UILabel()
    private let startButton = CircleButton(size: 50, backgroundColor: .mainPoint.withAlphaComponent(0.2), image: UIImage(systemName: "play"), tintColor: .mainPoint)
    var startButtonTapped: Observable<Void> { startButton.rx.tap.asObservable() }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttributes()
        setLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag() // 이전 구독 해제 후 새로운 구독 추가 -> reuse 방지
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomMissionCell {
    private func setAttributes() {
        
        let subtitleConfig = LabelConfiguration(font: .systemFont(ofSize: 12), color: .secondLabel, lines: 1)
        
        labelStackView.axis = .vertical
        labelStackView.spacing = 5
        
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .mainLabel
        
        subtitleLabel.font = subtitleConfig.font
        subtitleLabel.textColor = subtitleConfig.color
        
        cycleLabel.font = subtitleConfig.font
        cycleLabel.textColor = subtitleConfig.color
        
        timeLabel.font = .boldSystemFont(ofSize: 18)
        timeLabel.textColor = .mainLabel
        
        rightStackView.axis = .vertical
        rightStackView.spacing = 5
        rightStackView.alignment = .trailing
        
        startButton.layer.borderColor = UIColor.mainPoint.cgColor
        startButton.layer.borderWidth = 1
        
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
    func config(mission: MissionPayload) {
        titleLabel.text = mission.title
        subtitleLabel.text = "\(mission.concentrateTime)분 집중 / \(mission.breakTime)분 휴식"
        cycleLabel.text = "\(mission.cycle)사이클"
        
        let hour = (mission.concentrateTime + mission.breakTime) * mission.cycle / 60
        let minute = (mission.concentrateTime + mission.breakTime) * mission.cycle % 60
        
        // 필요한가? 
        if hour > 0 {
            timeLabel.text = "\(hour)h \(minute)m"
        } else {
            timeLabel.text = "\(minute)m"
        }
    }
}

