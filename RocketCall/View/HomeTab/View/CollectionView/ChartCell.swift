//
//  ChartCell.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/27/26.
//

import UIKit
import SnapKit
import SwiftUI

final class ChartCell: UICollectionViewCell {
    private let chartBaseCardView = BaseCardView()
    private let chartHostingController = UIHostingController(rootView: ChartView(data: DetailCollectionView.Item.weeklyData))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 16
        
        chartHostingController.view.backgroundColor = .clear
        
        addSubview(chartBaseCardView)
        addSubview(chartHostingController.view)
        
        chartBaseCardView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        chartHostingController.view.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.horizontalEdges.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChartCell {
    func update(with data: [Int: Int]) {

    }
}
