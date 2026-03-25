//
//  MissionView.swift
//  RocketCall
//
//  Created by 손영빈 on 3/24/26.
//

import UIKit
import SnapKit

enum MissionSection: Int, CaseIterable {
    case activatedMission
    case customMission
}

class MissionView: UIView {
    let titleView = TitleView(title: "계획된 임무", subTitle: "포모도로 타이머를 설정하고 시작하세요.", hasButton: true)
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttributes()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MissionView {
    private func setAttributes() {
        collectionView.backgroundColor = .background
    }
    private func setLayout() {
        [titleView, collectionView].forEach { addSubview($0) }
        
        titleView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

extension MissionView {
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            let sectionType = MissionSection.allCases[sectionIndex]
            switch sectionType {
            case .activatedMission:
                return self.makeActivatedSection()
            case .customMission:
                return self.makeCustomSection()
            }
        }
    }
    
    private func makeActivatedSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(160))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(160))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 20, trailing: 20)
        section.interGroupSpacing = 10
        
        return section
    }
    
    private func makeCustomSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 20, trailing: 20)
        section.interGroupSpacing = 10
        
        return section
    }
}

