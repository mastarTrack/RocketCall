//
//  AlarmCard.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/24/26.
//
import UIKit
import SnapKit
import Then

class AlarmCardView: BaseCardView {
    
}

extension AlarmCardView {
    func setLayout() {
        let colorChip = UIView().then {
            $0.backgroundColor = .subPoint
            $0.clipsToBounds = true
            $0.snp.makeConstraints {
                $0.width.equalToSuperview().multipliedBy(0.05)
            }
        }
     
        addSubview(colorChip)
        
        colorChip.snp.makeConstraints {
            $0.leading.verticalEdges.equalToSuperview()
        }
        
    }
}
