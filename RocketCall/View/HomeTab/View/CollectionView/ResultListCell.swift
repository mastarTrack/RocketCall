//
//  ResultListCell.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/27/26.
//

import UIKit
import SnapKit
import Then

final class ResultListCell: UICollectionViewCell {
    private let cardView = BaseCardView()
    
    private let titleLabel = UILabel(text: "미션", config: .sub14).then {
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    private let timeLabel = UILabel(
        text: "시간",
        config: LabelConfiguration(font: .boldSystemFont(ofSize: 18), color: .mainLabel, lines: 1)).then {
            $0.textAlignment = .right
        }
    
    private let dateLabel = UILabel(text: "날짜", config: .sub12)
    private let cycleLabel = UILabel(text: "사이클", config: .sub12).then {
        $0.textAlignment = .right
        $0.isHidden = true // 코어데이터에 cycle 정보가 없어서 hidden 처리
    }
    
    private let stateLabel = StateLabel(text: "✔️ 성공", config: .success)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ResultListCell {
    private func setAttributes() {
        contentView.backgroundColor = UIColor(red: 18/255.0, green: 26/255.0, blue: 48/255.0, alpha: 1.0)
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(red: 201/255.0, green: 209/255.0, blue: 232/255.0, alpha: 0.3).cgColor
    }
    
    private func setLayout() {
        let firstStack = UIStackView(arrangedSubviews: [titleLabel, timeLabel]).then {
            $0.axis = .horizontal
            $0.alignment = .bottom
            $0.spacing = 5
            
            timeLabel.setContentHuggingPriority(.required, for: .horizontal)
            timeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
        
        let secondStack = UIStackView(arrangedSubviews: [dateLabel, cycleLabel]).then {
            $0.axis = .horizontal
            $0.spacing = 5
            
            cycleLabel.setContentHuggingPriority(.required, for: .horizontal)
            cycleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
        
        
        contentView.addSubview(cardView)
        cardView.addSubview(firstStack)
        cardView.addSubview(secondStack)
        cardView.addSubview(stateLabel)
        
        cardView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        firstStack.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().inset(20)
        }
        
        secondStack.snp.makeConstraints {
            $0.top.equalTo(firstStack.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        stateLabel.snp.makeConstraints {
            $0.top.equalTo(secondStack.snp.bottom).offset(5)
            $0.leading.bottom.equalToSuperview().inset(20)
        }
    }
}

extension ResultListCell {
    func configure(with result: MissionResultPayload) {
        titleLabel.text = result.title
        timeLabel.text = "\(result.studyTime / 60)h \(result.studyTime % 60)m"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 dd일 (E)"
        dateLabel.text = dateFormatter.string(from: result.start)
        
        configureStateLabel(isCompleted: result.isCompleted)
    }
    
    private func configureStateLabel(isCompleted: Bool) {
        if isCompleted {
            stateLabel.backgroundColor = StateLabelConfiguration.success.backgroundColor
            stateLabel.textColor = StateLabelConfiguration.success.color
            stateLabel.text = "✓ 성공"
        } else {
            stateLabel.backgroundColor = StateLabelConfiguration.failure.backgroundColor
            stateLabel.textColor = StateLabelConfiguration.failure.color
            stateLabel.text = "x 실패"
        }
    }
}
