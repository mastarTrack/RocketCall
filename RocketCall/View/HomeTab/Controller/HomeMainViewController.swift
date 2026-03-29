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
    let mainController: MainController // 탭바 컨트롤러
    let homeMainView: HomeMainView
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
    init(mainController: MainController, viewModel: HomeViewModel) {
        self.mainController = mainController
        self.viewModel = viewModel
        self.homeMainView = HomeMainView(data: viewModel.weeklyData) // viewModel의 weeklyData와 바인딩
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
        
        // 알람 카드뷰 업데이트
        output.alarm
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [cardView = homeMainView.alarmCardView] result in
                switch result {
                case .success(let alarm):
                    cardView.configure(alarm: alarm)
                    
                case .failure(let error):
                    print(error) // 추후 처리 필요
                }
            })
            .disposed(by: disposeBag)
        
        // 통계 카드 업데이트
        output.sum
            .subscribe(onNext: { [homeMainView] result in
                switch result {
                case .success(let results):
                    homeMainView.totalTimeCardView.configure(results[TotalCardView.CardCategory.totalTime.rawValue])
                    homeMainView.missionCardView.configure(results[TotalCardView.CardCategory.totalCount.rawValue])
                case .failure(let error):
                    print(error)
                }
            })
            .disposed(by: disposeBag)
        
        // 차트뷰 데이터소스 - 에러 처리용
        output.chartRawData
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    print(error)
                }
            })
            .disposed(by: disposeBag)
        
        // 알람 카드 뷰 제스처
        let alarmCardTapGesture = UITapGestureRecognizer()
        homeMainView.alarmCardView.addGestureRecognizer(alarmCardTapGesture) // 제스처 추가
        
        alarmCardTapGesture.rx.event // 탭 이벤트
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { _ in }
            .subscribe(onNext: { [weak self] in
                self?.mainController.selectedIndex = 1 // 이벤트가 들어오면 tabBarController의 선택된 인덱스를 알람탭으로 변경
                
            })
            .disposed(by: disposeBag)
        
        // 차트 뷰 제스처
        let chartTapGesture = UITapGestureRecognizer()
        homeMainView.chartBaseCardView.addGestureRecognizer(chartTapGesture) // 제스처 추가
        
        chartTapGesture.rx.event // 탭 이벤트
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { _ in }
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.navigationController?.pushViewController(HomeDetailViewController(viewModel: self.viewModel), animated: true)
            })
            .disposed(by: disposeBag)
    }
}
