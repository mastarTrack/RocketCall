//
//  HomeMainViewController.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/24/26.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa

class HomeMainViewController: UIViewController {
    let homeMainView = HomeMainView()
    let viewModel: HomeViewModel
    
    let disposeBag = DisposeBag()
        
    override func loadView() {
        view = homeMainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        addChild(homeMainView.chartHostingController) // UIHostingVC와 현재 VC의 생명주기 동기화
        homeMainView.chartHostingController.didMove(toParent: self) // 자식 VC(hostingVC)에게 VC 계층에 추가되었음을 알림
        
        bind()
    }
    
    //MARK: init
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeMainViewController {
    private func bind() {
        let viewWillAppear = rx.viewWillAppear
        let didBecomeActive = NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification)
            .map { _ in }
            .skip(until: rx.viewDidAppear)
        
        let input = HomeViewModel.Input(
            fetchData: Observable.merge(viewWillAppear, didBecomeActive)
        )
        
        let output = viewModel.transform(input)
        
        output.alarm
            .subscribe(onNext: { [cardView = homeMainView.alarmCardView] result in
                switch result {
                case .success(let alarm):
                    if let alarm {
                        cardView.emptyAlarmImage.isHidden ? nil : cardView.toggleIsHidden()
                        
                        cardView.configure(alarm: alarm)
                    } else {
                        cardView.emptyAlarmImage.isHidden ? cardView.toggleIsHidden() : nil
                    }
                case .failure(let error):
                    print(error) // 추후 처리 필요
                }
            })
            .disposed(by: disposeBag)
        
        output.total
            .compactMap { result in
                if case .success(let result) = result { return result }
                return nil
            }
            .subscribe(onNext: { [homeMainView] total in
                homeMainView.totalTimeCardView.valueLabel.text = "\(total.totalTime / 60)시간"
                homeMainView.totalTimeCardView.detailLabel.text = "\(total.totalTime)분"
                homeMainView.missionCardView.valueLabel.text = "\(total.complete)회"
            })
            .disposed(by: disposeBag)

    }
}
