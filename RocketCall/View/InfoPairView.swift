//
//  InfoPairView.swift
//  RocketCall
//
//  Created by Yeseul Jang on 3/24/26.
//
import UIKit
import SnapKit
import Then

class InfoPairView: UIView {
    
    private let titleLabel = UILabel().then {
        $0.textColor = UIColor.lightGray
        $0.font = .systemFont(ofSize: 15, weight: .medium)
    }
    
    let dataLabel: UILabel
    
    init(title: String, data: String? = nil, dataLabel: UILabel? = nil) {
            self.dataLabel = dataLabel ?? UILabel().then {
                $0.textColor = .white
                $0.font = .systemFont(ofSize: 15, weight: .bold)
                $0.textAlignment = .right
            }
            
            super.init(frame: .zero)
            
            titleLabel.text = title
            if let data {
                self.dataLabel.text = data
            }
            
            configureUI()
            setLayout()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(titleLabel)
        addSubview(dataLabel)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        
        dataLabel.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(15)
        }
    }
}
