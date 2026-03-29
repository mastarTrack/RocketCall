//
//  HomeResultListViewController.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/29/26.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeResultListViewController: UIViewController {
    let viewModel: HomeViewModel
    let listView = HomeResultListView()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = listView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeResultListViewController {
    private func bind() {
        //MARK: Input
        let viewWillAppear = rx.viewWillAppear
        let didBecomeActive = NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification)
            .map { _ in }
            .skip(until: rx.viewDidAppear)
        
        let input = HomeViewModel.Input(
            fetchData: Observable.merge(viewWillAppear, didBecomeActive)
        )
        
        //MARK: Output
        let output = viewModel.transform(input)
        
        output.missionResults
            .subscribe(onNext: { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let results):
                    let items = self.converToItem(results)
                    listView.setSnapshot(with: items)
                case .failure(let error):
                    print(error)
                }
            })
            .disposed(by: disposeBag)
        
        listView.collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self else { return }
                guard let item = listView.dataSource.itemIdentifier(for: indexPath) else { return }
                
                switch item {
                case .result(let result):
                    let vc = MissionResultViewController(coreDataManager: self.viewModel.coreDataManager, resultId: result.id)
                    self.present(vc, animated: true)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func converToItem(_ results: [MissionResultPayload]) -> [DetailCollectionView.Item] {
        results.map {
            DetailCollectionView.Item.result($0)
        }
    }
}
