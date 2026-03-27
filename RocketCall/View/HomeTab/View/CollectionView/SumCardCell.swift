//
//  sumCardCell.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/27/26.
//

import UIKit
import SnapKit

final class SumCardCell: UICollectionViewCell {
    private let cardView = SmallCardView(type: .totalCount)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SumCardCell {
    private func setLayout() {
        contentView.addSubview(cardView)
        
        cardView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(type: SmallCardView.CardCategory, valueText: String, detailText: String) {
        cardView.configure(type: type, valueText: valueText, detailText: detailText)
    }
}
