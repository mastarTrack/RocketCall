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
        
        // 통계 업데이트
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
    
    private func convertToItem(_ result: HomeViewModel.TotalResult?, section: DetailCollectionView.Section) -> [DetailCollectionView.Item] {
        guard let result else { return [] }
        
        switch section {
        case .sum:
            let totalTime = DetailCollectionView.Item.sum(.totalTime, "\(result.totalTime / 60)시간", "\(result.totalTime)분")
            let leftTime = DetailCollectionView.Item.sum(.leftTime, "남은 시간", "N분")
            let complete = DetailCollectionView.Item.sum(.totalCount, "\(result.complete)분", "완료")
            let streak = DetailCollectionView.Item.sum(.streak, "\(result.streak)회", "계속 유지!")
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
