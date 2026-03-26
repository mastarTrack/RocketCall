//
//  MissionViewController.swift
//  RocketCall
//
//  Created by 손영빈 on 3/24/26.
//

import UIKit
import RxSwift
import RxCocoa

class MissionViewController: UIViewController {
    
    private let mainView = MissionView()
    private let disposeBag = DisposeBag()
    private let viewModel: MissionViewModel
    
    private var missions: [MissionPayload] = []
    
    let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        self.viewModel = MissionViewModel(coreDataManager: coreDataManager)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setDelegate()
        bind()
    }
}

extension MissionViewController {
    private func bind() {
        mainView.titleView.addButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                let nextVM = CreateMissionViewModel(coreDataManager: self.coreDataManager)
                let nextVC = CreateMissionViewController(viewModel: nextVM)
                self.navigationController?.pushViewController(nextVC, animated: true)
            }).disposed(by: disposeBag)
        
        let input = MissionViewModel.Input(initialze: Observable.just(()))
        let output = viewModel.transform(input)
        
        output.missions
            .subscribe(onNext: { [weak self] missions in
                self?.missions = missions
                self?.mainView.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

// Model 구현안됨 -> 추후 Diffable 변경 예정
extension MissionViewController {
    private func setDelegate() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(ActivatedMissionCell.self, forCellWithReuseIdentifier: ActivatedMissionCell.id)
        mainView.collectionView.register(CustomMissionCell.self, forCellWithReuseIdentifier: CustomMissionCell.id)
        mainView.collectionView.register(MissionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MissionHeaderView.id)
    }
}

extension MissionViewController: UICollectionViewDelegate {
    
}

extension MissionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionType = MissionSection.allCases[indexPath.section]
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MissionHeaderView.id, for: indexPath) as? MissionHeaderView else { return UICollectionReusableView() }
        header.config(title: sectionType.title)
        return header
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        MissionSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = MissionSection.allCases[section]
        
        switch sectionType {
        case .activatedMission:
            return 2
        case .customMission:
            return missions.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = MissionSection.allCases[indexPath.section]
        
        switch sectionType {
        case .activatedMission:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivatedMissionCell.id, for: indexPath) as? ActivatedMissionCell else { return UICollectionViewCell() }
            cell.config(cycleText: "1/4사이클", title: "25분 미션", time: "05:10")
            return cell
        case .customMission:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomMissionCell.id, for: indexPath) as? CustomMissionCell else { return UICollectionViewCell() }
            cell.config(mission: missions[indexPath.item])
            return cell
        }
    }
}
