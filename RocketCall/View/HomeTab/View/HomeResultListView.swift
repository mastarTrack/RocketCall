//
//  ResultListView.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/29/26.
//

import UIKit
import SnapKit
import Then

final class HomeResultListView: UIView {
    private let titleView = TitleView(title: "미션 결과", subTitle: "지금까지 수행한 미션 결과를 확인하세요", hasButton: false)
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCompositionalLayout()).then {
        $0.backgroundColor = .background
        $0.contentInset = .init(top: 0, left: 0, bottom: 50, right: 0)
    }
    
    private(set) lazy var dataSource = makeCollectionViewDiffableDataSource(collectionView)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeResultListView {
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

//MARK: set CollectionView
extension HomeResultListView {
    private func makeCompositionalLayout() ->  UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.contentInsetsReference = .layoutMargins
        
        return UICollectionViewCompositionalLayout (sectionProvider: { sectionIndex, environment in
            
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(0.28)
                )
            )
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(0.28)
                ),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            
            return section
        }, configuration: configuration)
    }
    
    private func makeCollectionViewDiffableDataSource(_ collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Int, DetailCollectionView.Item> {
        
        let resultCellRegistration = UICollectionView.CellRegistration<ResultListCell, DetailCollectionView.Item> { cell, indexPath, item in
            switch item {
            case .result(let payload):
                cell.configure(with: payload)
            default:
                break
            }
        }
        
        let dataSource = UICollectionViewDiffableDataSource<Int, DetailCollectionView.Item>(collectionView: collectionView) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(using: resultCellRegistration, for: indexPath, item: item)
        }
        
        return dataSource
    }
    
    func setSnapshot(with data: [DetailCollectionView.Item]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, DetailCollectionView.Item>()
        snapshot.appendSections([0])
        snapshot.appendItems(data, toSection: 0)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
