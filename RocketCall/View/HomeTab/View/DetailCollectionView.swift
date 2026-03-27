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
    
        enum Item: Hashable {
            case sum(SmallCardView.CardCategory, String, String) // 카테고리, value, detail
            case chart
            case progress
            case result
    
            func hash(into hasher: inout Hasher) {
                switch self {
                case .sum(let category, let value, let detail):
                    hasher.combine("total")
                case .chart:
                    hasher.combine("chart")
                case .progress:
                    hasher.combine("progress")
                case .result:
                    hasher.combine("result")
                }
            }
        }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
        collectionViewLayout = makeCompositionalLayout()
        layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 20)
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
        
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            switch Section(rawValue: sectionIndex) {
            case .sum:
                let section = self?.sumSectionLayout(environment: environment)
                return section
            case .chart:
                let section = self?.chartSectionLayout()
                return section
            case .progress:
                let section = self?.chartSectionLayout()
                return section
            case .result:
                let section = self?.resultSectionLayout(environment: environment)
                return section
            case .none:
                return self?.chartSectionLayout()
            }
        }
    }
    
    private func sumSectionLayout(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let environmentWidth = environment.container.effectiveContentSize.width
        let spacing: CGFloat = 8
        let itemWidth = (environmentWidth / 2) - 8
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(itemWidth),
                heightDimension: .absolute(itemWidth * 0.6)
            )
        )
        
        // 가로 그룹 - 2개 표시
        let innerGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(itemWidth * 0.6)
            ),
            repeatingSubitem: item,
            count: 2
        )
        
        innerGroup.interItemSpacing = .fixed(spacing)
        
        // 세로 그룹 - 4개 표시
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute((itemWidth * 0.6 * 2) + spacing)
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
                heightDimension: .fractionalHeight(1)
            )
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func resultSectionLayout(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let environmentWidth = environment.container.effectiveContentSize.width
        let spacing: CGFloat = 8
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        // 세로 그룹 - 4개 표시
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        
        return section
    }
}
