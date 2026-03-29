//
//  HomeCollectionHeaderView.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/29/26.
//
import UIKit
import SnapKit

final class HomeCollectionHeaderView: UICollectionReusableView {
    let headerView = HomeHeaderView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(headerView)
        
        headerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, hasButton: Bool) {
        headerView.configure(title: title, hasButton: hasButton)
    }
}
