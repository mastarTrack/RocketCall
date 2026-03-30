//
//  ContainerRowView.swift
//  RocketCall
//
//  Created by Yeseul Jang on 3/27/26.
//
import UIKit
import SnapKit
import Then

class ContainerRowView: UIView {
    private let dotView = CircleContainerView(size: 8)
    
    private let titleLabel = UILabel(config: .sub16).then {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    private let timeLabel = UILabel(config: .sub16).then {
        $0.textColor = .systemBlue
    }
    
    private let separatorView = SeparatorView()
    
    init(item: ContainerInfoItem, showsSeparator: Bool = true) {
        super.init(frame: .zero)
        configureUI()
        setLayout()
        configure(item: item, showsSeparator: showsSeparator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(dotView)
        addSubview(titleLabel)
        addSubview(timeLabel)
        addSubview(separatorView)
    }
    
    // 값 넣어줌
    private func configure(item: ContainerInfoItem, showsSeparator: Bool) {
        if let iconText = item.emoji {
            titleLabel.text = "\(iconText) \(item.title)"
        } else {
            titleLabel.text = item.title
        }
        
        timeLabel.text = item.value
        separatorView.isHidden = !showsSeparator
    }
    
    private func setLayout() {
        dotView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalTo(titleLabel)
        }
        
        // 제목 기준으로 잡아서 얘 따라서 잡음(위간격 여기서)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalTo(dotView.snp.trailing).offset(20)
        }
        
        timeLabel.snp.makeConstraints {
            $0.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(12) // 최소간격만 줌
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(titleLabel)
        }
        
        separatorView.snp.makeConstraints {
            // 아래간격 여기서
            $0.top.equalTo(titleLabel.snp.bottom).offset(18)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
        }
    }
}
