//
//  StopWatchRecordListView.swift
//  RocketCall
//
//  Created by Hanjuheon on 3/24/26.
//

import UIKit
import RxSwift
import SnapKit
import Then



/// 스탑워치 하단 레코드 뷰
class StopWatchRecordView: UIView {
   
    //MARK: - Enum
    enum RecordSection {
        case main
    }

    
    //MARK: - Components
    private let titleLabel = UILabel(
        text: "Checkpoint Records",
        config: .sub14
    )
    
    private lazy var recordCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(section: recordSection())
    ).then {
        $0.backgroundColor = .background
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<RecordSection ,RecordData>!
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .background
        configureUI()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

////MARK: - Binding
//extension StopWatchRecordView {
//    /// Binding 메소드
//    private func binding() {
//        //TODO: 한주헌 - 목업데이터 테스트 코드
//        applySnapshot(with: mockRecords)
//    }
//}

//MARK: - CollectionView Configure
extension StopWatchRecordView {
    /// SnapShot 생성 매소드
    func applySnapshot(with recordDatas: [RecordData]){
        var snapShot = NSDiffableDataSourceSnapshot<RecordSection,RecordData>()
        snapShot.appendSections([.main])
        snapShot.appendItems(recordDatas)
        dataSource.apply(snapShot,animatingDifferences: false)
    }
    
    
    /// DataSource 설정 메소드
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<RecordSection,RecordData>   (collectionView: recordCollectionView) { [weak self]
            collectionview, indexPath, item in
            guard let self else { return UICollectionViewCell() }
            
            let section = self.dataSource.snapshot().sectionIdentifiers
            let sectionType = section[indexPath.section]
            
            switch sectionType {
            case .main:
                guard let cell = collectionview.dequeueReusableCell(
                    withReuseIdentifier: RecordCell.id,
                    for: indexPath) as? RecordCell
                else { return UICollectionViewCell() }
                                
                cell.updateRecord(count: item.count,
                                  time: item.time,
                                  location: item.location,
                                  isLive: item.isLive)
                return cell
            }
        }
    }
    
    /// 레코드 섹션 생성 메소드
    private func recordSection()-> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                              heightDimension: .absolute(50)))
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                              heightDimension: .absolute(50)),
            subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12

        return section
    }
}


//MARK: - Configure UI
extension StopWatchRecordView {
    // UI 초기 설정 메소드
    func configureUI() {
        recordCollectionView.register(RecordCell.self, forCellWithReuseIdentifier: RecordCell.id)
        
        addSubview(titleLabel)
        addSubview(recordCollectionView)
        
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        recordCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}


@available(iOS 17.0, *)
#Preview {
    StopWatchRecordView()
}
