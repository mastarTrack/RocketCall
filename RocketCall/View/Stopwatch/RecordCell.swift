//
//  RecordCell.swift
//  RocketCall
//
//  Created by Hanjuheon on 3/24/26.
//

import UIKit
import SnapKit
import Then


class RecordCell: UICollectionViewCell {
    
    static let id = "RecordCell"
    
    private let countLabel = UILabel(
        text: "# 0",
        config: .sub14
    )
    
    private let  timerLabel = UILabel(
        text: "00:00.00",
        config: .missionLabel
    )
    
    private let locationLabel = UILabel(
        text: "계산 중...",
        config: .sub12
    ).then {
        $0.textColor = .thirdPoint
    }

    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .cardBackground
        contentView.backgroundColor = .mainPoint
        contentView.layer.cornerRadius = 16
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

//MARK: - Update UI
extension RecordCell {
    /// Update RecordCell Component Text
    func updateRecord(count: Int, time: String , location: String, isLive: Bool) {
        countLabel.text = "# \(count)"
        timerLabel.text = time
        locationLabel.text = location
        if !isLive {
            contentView.backgroundColor = .cardBackground
            contentView.layer.borderColor = UIColor.mainPoint.cgColor
            contentView.layer.borderWidth = 1
        }
        else {
            contentView.backgroundColor = .mainPoint
            contentView.layer.borderWidth = 0
        }
    }
}

//MARK: - Configure UI
extension RecordCell {
    func configureUI() {
        contentView.addSubview(countLabel)
        contentView.addSubview(timerLabel)
        contentView.addSubview(locationLabel)
        
        
        countLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
            $0.width.equalTo(50)
        }
        
        timerLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(countLabel.snp.trailing).offset(20)
        }
        
        locationLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(30)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    RecordCell()
}
