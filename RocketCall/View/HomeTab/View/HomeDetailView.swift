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
        
        let chartCellRegistration = UICollectionView.CellRegistration<ChartCell, DetailCollectionView.Item> { cell, indexPath, item in
            switch item {
            case .chart(let rawData):
                DetailCollectionView.Item.weeklyData.newValue(rawData) // 차트뷰 데이터 갱신
            default:
                break
            }
        }
        
        let progressCellRegistration = UICollectionView.CellRegistration<ProgressCell, DetailCollectionView.Item> { cell, indexPath, item in
            switch item {
            case .progress(let target):
                cell.configure(target: target)
            default:
                break
            }
        }
        
        let resultCellRegistration = UICollectionView.CellRegistration<ResultListCell, DetailCollectionView.Item> { cell, indexPath, item in
            switch item {
            case .result(let payload):
                cell.configure(with: payload)
            default:
                break
            }
        }
        
        let dataSource = UICollectionViewDiffableDataSource<DetailCollectionView.Section, DetailCollectionView.Item>(collectionView: collectionView) { collectionView, indexPath, item in
            switch DetailCollectionView.Section(rawValue: indexPath.section) {
            case .sum:
                return collectionView.dequeueConfiguredReusableCell(using: sumCardCellRegistration, for: indexPath, item: item)
            case .chart:
                return collectionView.dequeueConfiguredReusableCell(using: chartCellRegistration, for: indexPath, item: item)
            case .progress:
                return collectionView.dequeueConfiguredReusableCell(using: progressCellRegistration, for: indexPath, item: item)
            case .result:
                return collectionView.dequeueConfiguredReusableCell(using: resultCellRegistration, for: indexPath, item: item)
            default:
                fatalError("DetailCollectionView: 유효하지 않은 섹션입니다")
            }
        }
        
        return dataSource
    }
    
    func setSnapshot(with data: [[DetailCollectionView.Item]]) {
        var snapshot = NSDiffableDataSourceSnapshot<DetailCollectionView.Section, DetailCollectionView.Item>()
        snapshot.appendSections([.sum, .chart, .progress, .result])
        
        snapshot.appendItems(data[DetailCollectionView.Section.sum.rawValue], toSection: .sum)
        snapshot.appendItems(data[DetailCollectionView.Section.chart.rawValue], toSection: .chart)
        snapshot.appendItems(data[DetailCollectionView.Section.progress.rawValue], toSection: .progress)
        snapshot.appendItems(data[DetailCollectionView.Section.result.rawValue], toSection: .result)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
