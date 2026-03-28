//
//  DetailCollectionView.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/27/26.
//

import UIKit
import SnapKit

final class DetailCollectionView: UICollectionView {
    enum Section: Int {
        case sum = 0
        case chart
        case progress
        case result
    }
    
    //TODO: 타입 변경 필요
    enum Item: Hashable {
        case sum(HomeViewModel.SumResult)
        case chart([Int: Int])
        case progress(Planet) // 타입 변경 필요
        case result(MissionResultPayload) // 타입 변경 필요
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .sum(let result):
                hasher.combine("total")
                hasher.combine(result)
            case .chart(let rawData):
                hasher.combine("chart")
                hasher.combine(rawData)
            case .progress(let target):
                hasher.combine("progress")
                hasher.combine(target)
            case .result(let payload):
                hasher.combine("result")
                hasher.combine(payload.id)
            }
        }
        
        static let weeklyData = WeeklyData()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
        collectionViewLayout = makeCompositionalLayout()
        layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
        contentInset = .init(top: 0, left: 0, bottom: 50, right: 0)
        backgroundColor = .background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DetailCollectionView {
    private func makeCompositionalLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 10
        configuration.contentInsetsReference = .layoutMargins
        
        return UICollectionViewCompositionalLayout (sectionProvider: { [weak self] sectionIndex, environment in
            switch Section(rawValue: sectionIndex) {
            case .sum:
                let section = self?.sumSectionLayout(environment: environment)
                return section
            case .chart:
                let section = self?.chartSectionLayout()
                return section
            case .progress:
                let section = self?.progressSectionLayout()
                return section
            case .result:
                let section = self?.resultSectionLayout(environment: environment)
                return section
            case .none:
                return self?.chartSectionLayout()
            }
        }, configuration: configuration)
    }
    
    private func sumSectionLayout(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let environmentWidth = environment.container.effectiveContentSize.width
        let spacing: CGFloat = 8
        let itemWidth = (environmentWidth - 8) / 2
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(itemWidth),
                heightDimension: .absolute(itemWidth * 0.55)
            )
        )
        
        // 가로 그룹 - 2개 표시
        let innerGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(itemWidth * 0.55)
            ),
            repeatingSubitem: item,
            count: 2
        )
        
        innerGroup.interItemSpacing = .fixed(spacing)
        
        // 세로 그룹 - 4개 표시
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute((itemWidth * 1.1) + 8)
            ),
            repeatingSubitem: innerGroup,
            count: 2
        )
        
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func chartSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(0.8)
            )
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(0.8)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func progressSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(0.35)
            )
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(0.35)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func resultSectionLayout(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {        
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
    }
}
