//
//  AlarmListViewController.swift
//
//
//  Created by 김주희 on 3/23/26.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa


final class AlarmListViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewWillAppearTrigger = PublishRelay<Void>() // 화면 생성 벨
    private let refreshTrigger = PublishRelay<Void>() // 새로고침 벨
    private let deleteEvent = PublishRelay<Alarm>() // 삭제 벨
    private let toggleEvent = PublishRelay<(UUID, Bool)>() // 토글 벨
    
    
    // MARK: - UI Components
    private let titleView = TitleView(title: "알람", subTitle: "알람을 설정해주세요", hasButton: true)
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.backgroundColor = .background
        $0.register(AlarmListViewCell.self, forCellWithReuseIdentifier: AlarmListViewCell.identifier)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = false
        config.backgroundColor = .background
        
        // 스와이프 삭제 액션
        config.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            self?.makeDeleteSwipeAction(for: indexPath)
        }
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func makeDeleteSwipeAction(for indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let alarm = dataSource.itemIdentifier(for: indexPath) else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] _, _, completion in
            self?.deleteEvent.accept(alarm)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
    // MARK: - Diffable DataSource
    enum Section {
        case main
    }
    
    typealias Item = Alarm
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, alarmItem in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlarmListViewCell.identifier, for: indexPath) as? AlarmListViewCell else {
                return UICollectionViewCell()
            }
            // 셀에 데이터 삽입
            cell.configureAlarmListViewCell(with: alarmItem)
            
            // 셀에서 전달받아 토글이벤트에 넣어줌
            cell.onToggleTapped = { [weak self] isOn in
                self?.toggleEvent.accept((alarmItem.id, isOn))
            }
            return cell
        }
    }
    
    private func applySnapshot(with alarms: [Alarm]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(alarms, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    
    // MARK: - 초기화
    private let coreDataManager: CoreDataManager
    private let viewModel: AlarmListViewModel
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        self.viewModel = AlarmListViewModel(coreDataManager: coreDataManager)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setDataSource()
        bind()
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearTrigger.accept(())
    }
    
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .background
        view.addSubview(titleView)
        view.addSubview(collectionView)
        
        titleView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(10)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
    }
    
    
    // MARK: - Binding
    private func bind() {
        
        // MARK: Input
        let input = AlarmListViewModel.Input(
            viewWillAppear: viewWillAppearTrigger.asObservable(),
            refreshTrigger: refreshTrigger.asObservable(),
            deleteAlarm: deleteEvent.asObservable(),
            addTapped: titleView.addButton.rx.tap.asObservable(),
            itemSelected: collectionView.rx.itemSelected.compactMap { [weak self] in self?.dataSource.itemIdentifier(for: $0) },
            toggleAlarm: toggleEvent.asObservable()
        )
        
        
        // MARK:  Input -> VM
        let output = viewModel.transform(input: input)
        
        
        // MARK: VM -> Output
        // 최신 알람 목록으로 갱신해서 그리기
        output.alarms
            .drive(onNext: { [weak self] alarms in
                self?.applySnapshot(with: alarms)
            })
            .disposed(by: disposeBag)
        
        // 모달 띄우기
        output.showSettingModal
            .drive(onNext: { [weak self] payload in
                let vc = AlarmSettingViewController()
                vc.viewModel = AlarmSettingViewModel(existingAlarm: payload)
                vc.onSaveSuccess = {
                    self?.refreshTrigger.accept(())
                }
                self?.present(vc, animated: true)
                
                if let selected = self?.collectionView.indexPathsForSelectedItems?.first {
                    self?.collectionView.deselectItem(at: selected, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}


