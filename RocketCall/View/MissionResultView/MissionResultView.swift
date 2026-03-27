//
//  MissionResultView.swift
//  RocketCall
//
//  Created by Yeseul Jang on 3/24/26.
//
import UIKit
import SnapKit
import Then

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
        $0.textColor = UIColor.systemBlue
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.textAlignment = .center
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 35, weight: .bold)
        $0.textAlignment = .center
    }
    
    private let subtitleLabel = UILabel(config: .sub16).then {
        $0.textAlignment = .center
    }
    
    private let infoCardView = BaseCardView()
    
    private let missionNameTitleLabel = UILabel(text: "현재 끝난 미션", config: .sub16).then {
        $0.textAlignment = .center
    }
    
    private let missionNameValueLabel = UILabel(config: .main24Bold).then {
        $0.textAlignment = .center
    }
    
    private let durationRow = InfoPairView(title: "총 소요 시간")
    private let focusRow = InfoPairView(title: "집중 시간")
    private let startTimeRow = InfoPairView(title: "시작 시간")
    private let endTimeRow = InfoPairView(title: "끝난 시간")
    private let stateRow = StateRowView(title: "상태")
    
    private let Separator1 = SeparatorView()
    private let Separator2 = SeparatorView()
    private let Separator3 = SeparatorView()
    private let Separator4 = SeparatorView()
    private let Separator5 = SeparatorView()
    
    private let completedDateTitleLabel = UILabel(config: .sub16).then {
        $0.text = "완료 일시"
        $0.textAlignment = .center
    }
    
    private let completedDateValueLabel = UILabel(config: .sub16).then {
        $0.textAlignment = .center
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
    
    func configure(with payload: MissionResultPayload) {
        applyState(payload.isCompleted)
        
        missionNameValueLabel.text = payload.title
        durationRow.updateData(Self.formattedDuration(from: payload.start, to: payload.end))
        focusRow.updateData(Self.formattedHourMinute(payload.studyTime))
        startTimeRow.updateData(Self.dateFormatter.string(from: payload.start))
        endTimeRow.updateData(Self.dateFormatter.string(from: payload.end))
        completedDateValueLabel.text = Self.completedDateFormatter.string(from: payload.end)
        
        stateRow.updateState(payload.isCompleted)
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
        
        infoCardView.addSubview(durationRow)
        infoCardView.addSubview(Separator1)
        infoCardView.addSubview(focusRow)
        infoCardView.addSubview(Separator2)
        infoCardView.addSubview(startTimeRow)
        infoCardView.addSubview(Separator3)
        infoCardView.addSubview(endTimeRow)
        infoCardView.addSubview(Separator4)
        infoCardView.addSubview(stateRow)
        infoCardView.addSubview(completedDateTitleLabel)
        infoCardView.addSubview(completedDateValueLabel)
        
        contentView.addSubview(homeButton)
    }
    
    private func setLayout() {
        scrollView.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
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
        
        durationRow.snp.makeConstraints {
            $0.top.equalTo(missionNameValueLabel.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(25)
        }
        
        Separator1.snp.makeConstraints {
            $0.top.equalTo(durationRow.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(1)
        }
        
        focusRow.snp.makeConstraints {
            $0.top.equalTo(Separator1.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(25)
        }
        
        Separator2.snp.makeConstraints {
            $0.top.equalTo(focusRow.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(1)
        }
        
        startTimeRow.snp.makeConstraints {
            $0.top.equalTo(Separator2.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(25)
        }
        
        Separator3.snp.makeConstraints {
            $0.top.equalTo(startTimeRow.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(1)
        }
        
        endTimeRow.snp.makeConstraints {
            $0.top.equalTo(Separator3.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(25)
        }
        
        Separator4.snp.makeConstraints {
            $0.top.equalTo(endTimeRow.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(1)
        }
        
        stateRow.snp.makeConstraints {
            $0.top.equalTo(Separator4.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(25)
        }

        completedDateTitleLabel.snp.makeConstraints {
            $0.top.equalTo(stateRow.snp.bottom).offset(30)
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

// 날짜 및 시간 변경
extension MissionResultView {
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h:mm"
        return formatter
    }()
    
    private static let completedDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy. M. d. a h:mm:ss"
        return formatter
    }()
    
    private static func formattedDuration(from start: Date, to end: Date) -> String {
        let durationInSeconds = max(0, Int(end.timeIntervalSince(start)))
        return formattedHourMinute(durationInSeconds)
    }
    
    private static func formattedHourMinute(_ totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        if hours > 0 && minutes > 0 {
            return "\(hours)시간 \(minutes)분"
        }
        
        if hours > 0 {
            return "\(hours)시간"
        }
        
        if minutes > 0 {
            return "\(minutes)분 \(seconds)초"
        }
        
        return "\(seconds)초"
    }
}
