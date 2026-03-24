//
//  AlarmListViewCell.swift
//  RocketCall
//
//  Created by 김주희 on 3/23/26.
//

import UIKit
import SnapKit
import Then

final class AlarmListViewCell: UICollectionViewCell {
    
    
    static let identifier = "AlarmListViewCell"
    
    // MARK: - UI Components
    private let containerView = BaseCardView()
    
    private let timeLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 60, weight: .light)
        $0.textColor = .mainLabel
    }
    
    private let toggle = UISwitch().then {
        $0.onTintColor = .mainPoint
    }
    
    private let titleStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 6
    }
    
    private let alarmIcon = UIImageView()
    
    private let titleLabel = UILabel().then {
        $0.textColor = .mainLabel
        $0.font = .systemFont(ofSize: 16)
    }
    
    private let dateStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 6
        $0.alignment = .leading
    }
    
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    
    // MARK: - setup Layout
    private func setupLayout() {
        
        contentView.addSubview(containerView)
        
        [timeLabel, toggle, titleStackView, dateStackView].forEach { containerView.addSubview($0) }
        [alarmIcon, titleLabel].forEach { titleStackView.addArrangedSubview($0) }
        
        containerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.verticalEdges.equalToSuperview().inset(8)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.leading.equalToSuperview().inset(20)
        }
        
        toggle.snp.makeConstraints {
            $0.centerY.equalTo(timeLabel)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        titleStackView.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(6)
            $0.leading.equalTo(timeLabel.snp.leading)
        }
        
        dateStackView.snp.makeConstraints {
            $0.leading.equalTo(timeLabel.snp.leading)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    
    // MARK: - 데이터 입력
    func configureAlarmListViewCell(with alarm: Alarm) {
        timeLabel.text = String(format: "%02d:%02d", alarm.hour, alarm.minute)
        titleLabel.text = alarm.title
        
        containerView.isOn = alarm.isOn
        toggle.isOn = alarm.isOn
        alarmIcon.image = alarm.isOn ? UIImage(systemName: "alarm.waves.left.and.right.fill") : UIImage(systemName: "alarm")
        alarmIcon.tintColor = alarm.isOn ? .mainPoint : .lightGray
        
        let sortedDays = alarm.repeatDays.sorted { $0.rawValue < $1.rawValue }
        
        // 7일 모두 선택했을 때
        if sortedDays.count == 7 {
            let badge = createDateBadge(text: "매일")
            dateStackView.addArrangedSubview(badge)
            
        } else {
            for day in sortedDays {
                let badge = createDateBadge(text: day.koreanName)
                dateStackView.addArrangedSubview(badge)
            }
        }
    }
    
    
    // MARK: - 뱃지 찍어내는 메서드
    private func createDateBadge(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        
        // 뱃지 색상
        if text == "매일" {
            label.textColor = .mainLabel
            label.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        } else {
            label.textColor = .mainPoint
            label.backgroundColor = .mainPoint.withAlphaComponent(0.2)
        }
        
        // 뱃지 너비
        label.snp.makeConstraints {
            if label.text == "매일" {
                $0.width.equalTo(40)
            } else {
                $0.width.equalTo(30)
            }
            $0.height.equalTo(24)
        }

        return label
    }
}
//
//
//#Preview {
//    AlarmListViewController()
//}
