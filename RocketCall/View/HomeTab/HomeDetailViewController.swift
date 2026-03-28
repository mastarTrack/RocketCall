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
        let viewWillAppear = rx.viewWillAppear
        let didBecomeActive = NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification)
            .map { _ in }
            .skip(until: rx.viewDidAppear)
        
        let input = HomeViewModel.Input(
            fetchData: Observable.merge(viewWillAppear, didBecomeActive)
        )
        
        let output = viewModel.transform(input)
        
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
            .combineLatest(sumItems, chartItem, resultItems)
            .subscribe(onNext: { [weak self] sum, chart, result in
                guard let self else { return }
                
                
            })
        
        
        Observable
            .zip(output.total, output.missionResults)
            .subscribe(onNext: { [weak self] totalResult, fetchResult in
                guard let self else { return }
                
                var total: HomeViewModel.TotalResult?
                
                switch totalResult {
                case .success(let result): total = result
                case .failure(let error): print(error)
                }
                
                var missionResults: [MissionResultPayload]?
                switch fetchResult {
                case .success(let results): missionResults = results
                case .failure(let error): print(error)
                }
                
                let sum = self.convertToItem(total, section: .sum)
                let chart = self.convertToItem(total, section: .chart)
                let progress = self.convertToItem(total, section: .progress)
                
                let allResults = missionResults?.compactMap { DetailCollectionView.Item.result($0) } ?? []
                
                let results = allResults.count >= 5 ? Array(allResults[0...4]) : allResults
                
                detailView.setSnapshot(with: [sum, chart, progress, results])
            })
            .disposed(by: disposeBag)
        
    }
    
    private func convertToItem(_ result: [HomeViewModel.SumResult], section: DetailCollectionView.Section) -> [DetailCollectionView.Item] {
        guard let result else { return [] }
        
        switch section {
        case .sum:
            let totalTime = DetailCollectionView.Item.sum(result[TotalCardView.CardCategory.totalTime.rawValue])
            let leftTime = DetailCollectionView.Item.sum(result[TotalCardView.CardCategory.leftTime.rawValue])
            let complete = DetailCollectionView.Item.sum(result[TotalCardView.CardCategory.totalCount.rawValue])
            let streak = DetailCollectionView.Item.sum(result[TotalCardView.CardCategory.streak.rawValue])

            return [totalTime, leftTime, complete, streak]
            
        case .chart:
            return [DetailCollectionView.Item.chart(result.weeklyRawData)]
            
        case .progress:
            return [DetailCollectionView.Item.progress(result.target!)]
            
        case .result:
            return []
        }
    }
}
