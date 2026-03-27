//
//  HomeDetailView.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/27/26.
//

import UIKit
import SnapKit

final class HomeDetailView: UIView {
    private let titleView = TitleView(title: "상세 기록", subTitle: "당신의 우주 여정", hasButton: false)
    let collectionView = DetailCollectionView()
    private lazy var dataSource = makeCollectionViewDiffableDataSource(collectionView)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeDetailView {
    private func setLayout() {
        addSubview(titleView)
        addSubview(collectionView)
        
        titleView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

//MARK: CollectionView
extension HomeDetailView {
    private func makeCollectionViewDiffableDataSource(_ collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<DetailCollectionView.Section, DetailCollectionView.Item> {
        
        let sumCardCellRegistration = UICollectionView.CellRegistration<SumCardCell, DetailCollectionView.Item> { cell, indexPath, item in
            switch item {
            case .sum(let type, let value, let detail):
                cell.configure(type: type, valueText: value, detailText: detail)
            default:
                break
            }
        }
        
        
    }
}
