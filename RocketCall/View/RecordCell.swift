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
        config: .subtext
    )
    
    private let  timerLabel = UILabel(
        text: "00:00.00",
        config: .text
    )
    
    private let locationLabel = UILabel(
        text: "계산 중...",
        config: .thirdPointText
    ).then {
        $0.font = .boldSystemFont(ofSize: 18)
    }
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mainPoint
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension RecordCell {
    func setRecord(count: Int, time: String , location: String) {
        countLabel.text = "# \(count)"
        timerLabel.text = time
        locationLabel.text = location
        backgroundColor = .cardBackground
        contentView.layer.borderColor = UIColor.mainPoint.cgColor
        contentView.layer.borderWidth = 1
    }
}

//MARK: - Configure UI
extension RecordCell {
    func configureUI() {
        contentView.addSubview(countLabel)
        contentView.addSubview(timerLabel)
        contentView.addSubview(locationLabel)
        
        contentView.layer.cornerRadius = 14
        
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
