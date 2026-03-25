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
        binding()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

//MARK: - Binding
extension StopWatchRecordView {
    /// Binding 메소드
    private func binding() {
        //TODO: 한주헌 - 목업데이터 테스트 코드
        applySnapshot(with: mockRecords)
    }
}

//MARK: - CollectionView Configure
extension StopWatchRecordView {
    /// SnapShot 생성 매소드
    func applySnapshot(with recordDatas: [RecordData]){
        var snapShot = NSDiffableDataSourceSnapshot<RecordSection,RecordData>()
        snapShot.appendSections([.main])
        snapShot.appendItems(recordDatas)
        dataSource.apply(snapShot,animatingDifferences: true)
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
                
                cell.setRecord(count: item.count, time: formatTime(item.time), location: item.location)
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
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

//MARK: -
//TODO: - 한주헌 - ViewModel로 이관 예정
struct RecordData: Hashable {
    var count : Int
    var time : Double
    var location : String
}

enum RecordSection {
    case main
}

let mockRecords: [RecordData] = [
    RecordData(count: 1, time: 12.34, location: "Launch Pad"),
    RecordData(count: 2, time: 28.91, location: "Troposphere"),
    RecordData(count: 3, time: 45.72, location: "Stratosphere"),
    RecordData(count: 4, time: 63.18, location: "Mesosphere"),
    RecordData(count: 5, time: 98.44, location: "Thermosphere"),
    RecordData(count: 6, time: 132.76, location: "Exosphere"),
    RecordData(count: 7, time: 215.30, location: "Moon Orbit")
]

func formatTime(_ time: Double) -> String {
    let minutes = Int(time) / 60
    let seconds = Int(time) % 60
    let centiseconds = Int((time - floor(time)) * 100)
    
    return String(format: "%02d:%02d.%02d", minutes, seconds, centiseconds)
}


@available(iOS 17.0, *)
#Preview {
    StopWatchRecordView()
}
