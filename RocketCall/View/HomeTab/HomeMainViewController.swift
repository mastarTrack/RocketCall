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
        
        let allSamples: [MissionResultPayload] = [
            // MARK: - Last Week (3/16 ~ 3/22)
            .init(id: UUID(), title: "Algo",
                  start: makeDate("2026-03-16 09:00"),
                  end: makeDate("2026-03-16 11:00"),
                  studyTime: 120, isCompleted: true),

            .init(id: UUID(), title: "iOS",
                  start: makeDate("2026-03-16 13:00"),
                  end: makeDate("2026-03-16 14:30"),
                  studyTime: 90, isCompleted: true),

            .init(id: UUID(), title: "Algo",
                  start: makeDate("2026-03-17 10:00"),
                  end: makeDate("2026-03-17 12:00"),
                  studyTime: 120, isCompleted: true),

            .init(id: UUID(), title: "CS",
                  start: makeDate("2026-03-18 09:00"),
                  end: makeDate("2026-03-18 10:30"),
                  studyTime: 90, isCompleted: true),

            .init(id: UUID(), title: "iOS",
                  start: makeDate("2026-03-18 20:00"),
                  end: makeDate("2026-03-18 21:00"),
                  studyTime: 60, isCompleted: true),

            .init(id: UUID(), title: "Algo",
                  start: makeDate("2026-03-19 14:00"),
                  end: makeDate("2026-03-19 16:00"),
                  studyTime: 120, isCompleted: false),

            .init(id: UUID(), title: "CS",
                  start: makeDate("2026-03-20 10:00"),
                  end: makeDate("2026-03-20 12:00"),
                  studyTime: 120, isCompleted: true),

            .init(id: UUID(), title: "iOS",
                  start: makeDate("2026-03-21 15:00"),
                  end: makeDate("2026-03-21 17:00"),
                  studyTime: 120, isCompleted: true),

            .init(id: UUID(), title: "Algo",
                  start: makeDate("2026-03-22 09:00"),
                  end: makeDate("2026-03-22 10:00"),
                  studyTime: 60, isCompleted: true),

            .init(id: UUID(), title: "CS",
                  start: makeDate("2026-03-22 20:00"),
                  end: makeDate("2026-03-22 21:30"),
                  studyTime: 90, isCompleted: true),

            // MARK: - This Week (3/23 ~ 3/29)
            .init(id: UUID(), title: "Algo",
                  start: makeDate("2026-03-23 09:00"),
                  end: makeDate("2026-03-23 10:00"),
                  studyTime: 60, isCompleted: true),

            .init(id: UUID(), title: "iOS",
                  start: makeDate("2026-03-23 20:00"),
                  end: makeDate("2026-03-23 21:00"),
                  studyTime: 60, isCompleted: true),

            .init(id: UUID(), title: "CS",
                  start: makeDate("2026-03-24 10:00"),
                  end: makeDate("2026-03-24 12:00"),
                  studyTime: 120, isCompleted: true),

            .init(id: UUID(), title: "Algo",
                  start: makeDate("2026-03-25 09:00"),
                  end: makeDate("2026-03-25 11:00"),
                  studyTime: 120, isCompleted: true),

            .init(id: UUID(), title: "iOS",
                  start: makeDate("2026-03-26 14:00"),
                  end: makeDate("2026-03-26 16:00"),
                  studyTime: 120, isCompleted: true),

            .init(id: UUID(), title: "CS",
                  start: makeDate("2026-03-27 19:00"),
                  end: makeDate("2026-03-27 21:00"),
                  studyTime: 120, isCompleted: false),

            .init(id: UUID(), title: "Algo",
                  start: makeDate("2026-03-28 10:00"),
                  end: makeDate("2026-03-28 13:00"),
                  studyTime: 180, isCompleted: true),

            .init(id: UUID(), title: "iOS",
                  start: makeDate("2026-03-29 09:00"),
                  end: makeDate("2026-03-29 11:00"),
                  studyTime: 120, isCompleted: true),

            .init(id: UUID(), title: "CS",
                  start: makeDate("2026-03-29 15:00"),
                  end: makeDate("2026-03-29 16:00"),
                  studyTime: 60, isCompleted: true),

            .init(id: UUID(), title: "Algo",
                  start: makeDate("2026-03-25 20:00"),
                  end: makeDate("2026-03-25 21:00"),
                  studyTime: 60, isCompleted: true)
        ]
        
        allSamples.forEach {
            do {
                try viewModel.coreDataManager.createMissionResultEntity(result: $0)
            } catch {
                print(error)
            }
        }
        
        
    }
    
    //MARK: init
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        self.homeMainView = HomeMainView(data: viewModel.weeklyData)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeDate(_ string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        return formatter.date(from: string)!
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
        
        // 통계 업데이트
        output.total
            .compactMap { result in
                if case .success(let result) = result { return result }
                return nil
            }
            .subscribe(onNext: { [homeMainView] total in
                // 카드뷰 업데이트
                homeMainView.totalTimeCardView.valueLabel.text = "\(total.totalTime / 60)시간"
                homeMainView.totalTimeCardView.detailLabel.text = "\(total.totalTime)분"
                homeMainView.missionCardView.valueLabel.text = "\(total.complete)회"
            })
            .disposed(by: disposeBag)
    }
}
