//
//  HomeDetailViewController.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/27/26.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeDetailViewController: UIViewController {
    let detailView = HomeDetailView()
    let viewModel: HomeViewModel
    let disposeBag = DisposeBag()
    
    //MARK: init
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View LifeCycle
    override func loadView() {
        self.view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }    
}

extension HomeDetailViewController {
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
        
        //MARK: set collectionView snapSHot
        // Sum Section Item
        let sum: Observable<[HomeViewModel.SumResult]> = output.sum
            .map {
                switch $0 {
                case .success(let results):
                    return results
                case .failure(let error):
                    print(error)
                    return []
                }
            }
            .share()
        
        let sumItems = sum
            .map { sum in
                let totalTime = DetailCollectionView.Item.sum(sum[TotalCardView.CardCategory.totalTime.rawValue])
                let leftTime = DetailCollectionView.Item.sum(sum[TotalCardView.CardCategory.leftTime.rawValue])
                let complete = DetailCollectionView.Item.sum(sum[TotalCardView.CardCategory.totalCount.rawValue])
                let streak = DetailCollectionView.Item.sum(sum[TotalCardView.CardCategory.streak.rawValue])
                
                return [totalTime, leftTime, complete, streak]
            }
            .share()

        // Chart Section Item
        let chartData = output.chartRawData
            .map {
                switch $0 {
                case .success(let data):
                    return data
                case .failure(let error):
                    print(error)
                    return [:]
                }
            }
            .share()
        
        let chartItem = chartData
            .map {
                return [DetailCollectionView.Item.chart($0)]
            }
            .share()
        
        // Progress Section Item
        let progress = output.progressStatus
            .map {
                switch $0 {
                case .success(let status):
                    return status
                case .failure(let error):
                    print(error)
                    return HomeViewModel.ProgressStatus(current: .earth, target: .moon, progress: 0)
                }
            }
            .share()
        
        let progressItem = progress
            .map {
                return [DetailCollectionView.Item.progress($0)]
            }
            .share()
        
        // Result Section Item
        let results = output.missionResults
            .map {
                switch $0 {
                case .success(let results):
                    return results
                case .failure(let error):
                    print(error)
                    return []
                }
            }
            .share()
        
        let resultItems = results
            .map { results in
                let allResults = results.compactMap { DetailCollectionView.Item.result($0) }
                return allResults.count >= 5 ? Array(allResults[0...4]) : allResults
            }
            .share()
        
        // CollectionView 업데이트
        Observable
            .combineLatest(sumItems, chartItem, progressItem, resultItems)
            .subscribe(onNext: { [detailView] sum, chart, progress, result in
                detailView.setSnapshot(with: [sum, chart, progress, result])
            })
            .disposed(by: disposeBag)
        
        //MARK: collectionView event
        detailView.infoButtonTappedRelay
            .subscribe(onNext: { [weak self] item in
                self?.present(HomeTimeContainerViewController(), animated: true)
            })
            .disposed(by: disposeBag)
        
        detailView.collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self else { return }
                guard let item = self.detailView.dataSource.itemIdentifier(for: indexPath) else { return }
                
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
    
    
}
