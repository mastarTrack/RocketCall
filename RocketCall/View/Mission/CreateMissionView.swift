//
//  CreateMissionView.swift
//  RocketCall
//
//  Created by 손영빈 on 3/25/26.
//

import UIKit
import SnapKit

class CreateMissionView: UIView {
    
    private let titleView = TitleView(title: "미션 계획", subTitle: "커스텀 뽀모도로를 설정하세요.", hasButton: false)
    
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    
    private let quickTitleLabel = UILabel()
    private let quickGridStackView = UIStackView()
    private let quickItems: [(icon: String, title: String, subtitle: String)] = [
        ("moon.stars.fill", "25분 미션", "25분 여행"),
        ("moon.stars.fill", "50분 미션", "50분 여행"),
        ("moon.stars.fill", "90분 미션", "90분 여행"),
        ("moon.stars.fill", "120분 미션", "120분 여행")
    ]
    
    private let missionNameLabel = UILabel()
    private let missionNameField = UITextField()
    
    let studyStepper = CustomStepper(title: "집중 시간", subtitle: "분 단위로 입력해주세요.", initialValue: 0)
    let restStepper = CustomStepper(title: "휴식 시간", subtitle: "분 단위로 입력해주세요.", initialValue: 0)
    let cycleStepper = CustomStepper(title: "반복 횟수", subtitle: "반복할 횟수를 설정해주세요.", initialValue: 0)
    
    private let summaryCard = BaseCardView()
    private let totalTimeLabel = UILabel()
    let totalTimeValueLabel = UILabel()
    private let intervalLabel = UILabel()
    let intervalValueLabel = UILabel()
    
    let createButton = RectangleButton(title: "미션 생성", image: UIImage(systemName: "play"), backgroundColor: .mainPoint)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttributes()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CreateMissionView {
    private func setAttributes() {
        self.backgroundColor = .background
        scrollView.showsVerticalScrollIndicator = false
        
        let labelConfig = LabelConfiguration.missionLabel
        let sub16Config = LabelConfiguration.sub16
        
        quickTitleLabel.text = "빠른 선택"
        quickTitleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        quickTitleLabel.textColor = .mainLabel
        
        quickGridStackView.axis = .vertical
        quickGridStackView.spacing = 10
        
        missionNameLabel.text = "미션명"
        missionNameLabel.font = labelConfig.font
        missionNameLabel.textColor = labelConfig.color
        missionNameLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        missionNameField.attributedPlaceholder = NSAttributedString(
            string: "미션명을 입력해주세요.",
            attributes: [.foregroundColor: UIColor.secondLabel ]
        )
        missionNameField.font = labelConfig.font
        missionNameField.textColor = labelConfig.color
        missionNameField.layer.cornerRadius = 10
        missionNameField.backgroundColor = .cardBackground
        missionNameField.layer.borderWidth = 1
        missionNameField.layer.borderColor = UIColor(red: 201/255.0, green: 209/255.0, blue: 232/255.0, alpha: 0.3).cgColor
        missionNameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        missionNameField.leftViewMode = .always
        
        totalTimeLabel.text = "총 소요 시간"
        totalTimeLabel.font = sub16Config.font
        totalTimeLabel.textColor = sub16Config.color
        
        totalTimeValueLabel.font = LabelConfiguration.main24Bold.font
        totalTimeValueLabel.textColor = LabelConfiguration.main24Bold.color
        totalTimeValueLabel.textAlignment = .right
        
        intervalLabel.text = "반복 주기"
        intervalLabel.font = sub16Config.font
        intervalLabel.textColor = sub16Config.color
        
        intervalValueLabel.font = sub16Config.font
        intervalValueLabel.textColor = sub16Config.color
        intervalValueLabel.textAlignment = .right
        
        
        
    }
    private func setLayout() {
        [titleView,scrollView].forEach { addSubview($0) }
        scrollView.addSubview(contentStackView)
        
        titleView.snp.makeConstraints {
            $0.top.leading.equalTo(safeAreaLayoutGuide)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentStackView.axis = .vertical
        contentStackView.spacing = 20
        
        contentStackView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-20)
            $0.width.equalTo(scrollView).offset(-40)
        }
        
        createGrid() //Grid 생성
        
        let missionNameRowStack = UIStackView(arrangedSubviews: [missionNameLabel,missionNameField])
        missionNameRowStack.axis = .horizontal
        missionNameRowStack.spacing = 30
        missionNameRowStack.alignment = .center
        
        missionNameField.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        let totalRowStack = UIStackView(arrangedSubviews: [totalTimeLabel, totalTimeValueLabel])
        totalRowStack.axis = .horizontal
        totalRowStack.distribution = .fillEqually
        
        let intervalRowStack = UIStackView(arrangedSubviews: [intervalLabel, intervalValueLabel])
        intervalRowStack.axis = .horizontal
        intervalRowStack.distribution = .fillEqually
        
        let summaryStack = UIStackView(arrangedSubviews: [totalRowStack, intervalRowStack])
        summaryStack.axis = .vertical
        summaryStack.spacing = 10
        
        summaryCard.addSubview(summaryStack)
        summaryStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        
        createButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        [quickTitleLabel, quickGridStackView, missionNameRowStack, studyStepper, restStepper, cycleStepper, summaryCard, createButton].forEach { contentStackView.addArrangedSubview($0) }
    }
}

extension CreateMissionView {
    private func createGrid() {
        for row in 0..<2 {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 10
            rowStack.distribution = .fillEqually
            rowStack.snp.makeConstraints {
                $0.height.equalTo(rowStack.snp.width).dividedBy(2)
            }
            for column in 0..<2 {
                let item = quickItems[row * 2 + column]
                let view = BaseCardView()
                
                let iconImageView = UIImageView(image: UIImage(systemName: item.icon))
                iconImageView.tintColor = .white
                iconImageView.contentMode = .scaleAspectFit
                iconImageView.snp.makeConstraints {
                    $0.size.equalTo(50)
                }
                
                let titleLabel = UILabel()
                titleLabel.text = item.title
                titleLabel.font = .boldSystemFont(ofSize: 16)
                titleLabel.textColor = .mainLabel
                
                let subtitleLabel = UILabel()
                subtitleLabel.text = item.subtitle
                subtitleLabel.font = .boldSystemFont(ofSize: 12)
                subtitleLabel.textColor = .systemBlue
                
                let stackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel, subtitleLabel])
                stackView.axis = .vertical
                stackView.alignment = .leading
                stackView.spacing = 8
                
                view.addSubview(stackView)
                stackView.snp.makeConstraints {
                    $0.top.leading.trailing.equalToSuperview().inset(20)
                    $0.bottom.lessThanOrEqualToSuperview().inset(20)
                }
                rowStack.addArrangedSubview(view)
            }
            quickGridStackView.addArrangedSubview(rowStack)
        }
    }
}
