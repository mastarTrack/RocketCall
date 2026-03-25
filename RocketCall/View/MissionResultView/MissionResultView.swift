//
//  MissionResultView.swift
//  RocketCall
//
//  Created by Yeseul Jang on 3/24/26.
//
import UIKit
import SnapKit
import Then
// 원
// 헤더 스택 뷰
// 카드뷰
// 하단 버튼

struct MissionResultData {
    let state: Bool
    let missionName: String
    let route: String
    let duration: String
    let type: String
    let statusText: String
    let completedDate: String
}

final class MissionResultView: UIView {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let iconCircleView = CircleContainerView(size: 100)
    
    private let resultImageView = UIImageView().then {
        $0.image = UIImage(systemName: "checkmark.circle")
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFit
    }
    
    private let coloredLabel = UILabel().then {
        $0.text = "✓ 미션 성공"
        $0.textColor = UIColor.systemBlue
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.textAlignment = .center
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "미션 완료!"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 35, weight: .bold)
        $0.textAlignment = .center
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "여정을 성공적으로 완료했습니다"
        $0.textColor = UIColor.lightGray
        $0.font = .systemFont(ofSize: 15, weight: .medium)
        $0.textAlignment = .center
    }
    
    private let infoCardView = BaseCardView()
    
    private let missionNameTitleLabel = UILabel().then {
        $0.text = "현재 미션"
        $0.textColor = UIColor.lightGray
        $0.font = .systemFont(ofSize: 15, weight: .medium)
        $0.textAlignment = .center
    }
    
    private let missionNameValueLabel = UILabel().then {
        $0.text = "계획된 미션"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 25, weight: .bold)
        $0.textAlignment = .center
    }
    
    private let routeRow = InfoPairView(title: "경로", data: "지구 → 달")
    private let durationRow = InfoPairView(title: "소요 시간", data: "00:14")
    private let typeRow = InfoPairView(title: "유형", data: "계획된 미션")
    private let stateRow = StateRowView(title: "상태")
    
    private let Seperater1 = SeperaterView()
    private let Seperater2 = SeperaterView()
    private let Seperater3 = SeperaterView()
    private let Seperater4 = SeperaterView()
    
    private let completedDateTitleLabel = UILabel().then {
        $0.text = "완료 일시"
        $0.textColor = UIColor.gray
        $0.font = .systemFont(ofSize: 15, weight: .medium)
        $0.textAlignment = .center
    }
    
    private let completedDateValueLabel = UILabel().then {
        $0.text = "2026. 3. 20. 오후 5:41:08"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 15, weight: .medium)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    let homeButton = RectangleButton(title: "홈으로 돌아가기", color: .subLabel) .then {
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        $0.backgroundColor = UIColor.white.withAlphaComponent(0.1)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setLayout()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with data: MissionResultData) {
        applyState(data.state)
        
        missionNameValueLabel.text = data.missionName
        routeRow.updateData(data.route)
        durationRow.updateData(data.duration)
        typeRow.updateData(data.type)
        completedDateValueLabel.text = data.completedDate
        
        stateRow.updateState(data.state)
    }
    
    private func applyState(_ state: Bool) {
        switch state {
        case true:
            iconCircleView.backgroundColor = .mainPoint
            resultImageView.image = UIImage(systemName: "checkmark.circle")
            coloredLabel.text = "✓ 미션 성공"
            coloredLabel.textColor = .systemGreen
            titleLabel.text = "미션 완료!"
            subtitleLabel.text = "여정을 성공적으로 완료했습니다"
            
        case false:
            iconCircleView.backgroundColor = .systemRed
            resultImageView.image = UIImage(systemName: "xmark.circle")
            coloredLabel.text = "✗ 미션 실패"
            coloredLabel.textColor = .systemRed
            titleLabel.text = "미션 실패"
            subtitleLabel.text = "여정을 완료하지 못했습니다"
        }
    }
    
    private func configureUI() {
        // 스크롤뷰 추가
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // 헤더 추가
        contentView.addSubview(iconCircleView)
        iconCircleView.addSubview(resultImageView)
        contentView.addSubview(coloredLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        // 카드뷰 추가
        contentView.addSubview(infoCardView)
        infoCardView.addSubview(missionNameTitleLabel)
        infoCardView.addSubview(missionNameValueLabel)
        
        infoCardView.addSubview(routeRow)
        infoCardView.addSubview(Seperater1)
        infoCardView.addSubview(durationRow)
        infoCardView.addSubview(Seperater2)
        infoCardView.addSubview(typeRow)
        infoCardView.addSubview(Seperater3)
        infoCardView.addSubview(stateRow)
        infoCardView.addSubview(Seperater4)
        infoCardView.addSubview(completedDateTitleLabel)
        infoCardView.addSubview(completedDateValueLabel)
        
        contentView.addSubview(homeButton)
    }
    
    private func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        iconCircleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        }
        
        resultImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(60)
        }
        
        coloredLabel.snp.makeConstraints {
            $0.top.equalTo(iconCircleView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(coloredLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        
        infoCardView.isOn = true
        infoCardView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        missionNameTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        
        missionNameValueLabel.snp.makeConstraints {
            $0.top.equalTo(missionNameTitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        
        routeRow.snp.makeConstraints {
            $0.top.equalTo(missionNameValueLabel.snp.bottom).offset(35)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(25)
        }
        
        Seperater1.snp.makeConstraints {
            $0.top.equalTo(routeRow.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(1)
        }
        
        durationRow.snp.makeConstraints {
            $0.top.equalTo(Seperater1.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(25)
        }
        
        Seperater2.snp.makeConstraints {
            $0.top.equalTo(durationRow.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(1)
        }
        
        typeRow.snp.makeConstraints {
            $0.top.equalTo(Seperater2.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(25)
        }
        
        Seperater3.snp.makeConstraints {
            $0.top.equalTo(typeRow.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(1)
        }
        
        stateRow.snp.makeConstraints {
            $0.top.equalTo(Seperater3.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(25)
        }
        
        Seperater4.snp.makeConstraints {
            $0.top.equalTo(stateRow.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(1)
        }
        
        completedDateTitleLabel.snp.makeConstraints {
            $0.top.equalTo(Seperater4.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        
        completedDateValueLabel.snp.makeConstraints {
            $0.top.equalTo(completedDateTitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.bottom.equalToSuperview().offset(-25)
        }
        
        homeButton.snp.makeConstraints {
            $0.top.equalTo(infoCardView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(60)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
}

class SeperaterView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white.withAlphaComponent(0.1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
