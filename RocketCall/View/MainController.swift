//
//  MainController.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/23/26.
//
import UIKit
import SnapKit
import RxSwift

class MainController: UITabBarController {
    let coreDataManager = CoreDataManager()
    lazy var timerViewModel = TimerViewModel(coreDataManager: coreDataManager)
    
    private let disposeBag = DisposeBag()
    
    override var childForStatusBarStyle: UIViewController? {
        selectedViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        tabBar.tintColor = .mainPoint
        self.view.backgroundColor = .background
        
        // 타이머 알림 누르면 MissionViewController로 연결
        NotificationManager.shared.timerNotificationTapped
            .subscribe(onNext: { [weak self] in
                self?.selectedIndex = 2
            })
            .disposed(by: disposeBag)
        
        // 사용자가 앱을 사용하고 있을때 미션결과화면을 띄우도록 함
        timerViewModel.missionResult
            .observe(on: MainScheduler.instance) // 메인스레드 처리하기 필수!!
        // 결과 id로 미션결과창 호출
            .subscribe(onNext: { [weak self] resultId in
                self?.showMissionResult(resultId: resultId)
            })
            .disposed(by: disposeBag)
    }
}

extension MainController {
    private func configure() {
        let firstVC = CustomNavigationController(rootViewController: HomeMainViewController(mainController: self, viewModel: HomeViewModel(coreDataManager: coreDataManager)))
        let secondVC = CustomNavigationController(rootViewController: AlarmListViewController(coreDataManager: coreDataManager))
        let thirdVC = UINavigationController(rootViewController: MissionViewController(coreDataManager: coreDataManager, timerViewModel: timerViewModel))
        let fourthVC = CustomNavigationController(rootViewController: StopWatchViewController())
        
        firstVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
        secondVC.tabBarItem = UITabBarItem(title: "알람", image: UIImage(systemName: "alarm"), tag: 1)
        thirdVC.tabBarItem = UITabBarItem(title: "미션", image: UIImage(systemName: "timer"), tag: 2)
        fourthVC.tabBarItem = UITabBarItem(title: "자유항행", image: UIImage(systemName: "stopwatch"), tag: 3)
        
        viewControllers = [firstVC, secondVC, thirdVC, fourthVC]
    }
    // 결과가 오면 미션결과 띄워주는 메서드
    private func showMissionResult(resultId: UUID) {
        selectedIndex = 2
        // 네비게이션 컨트롤러 꺼냄
        guard let missionNavigationController = viewControllers?[2] as? UINavigationController else { return }
        // 이미 상단이 미션결과VC이면 확인한후 pop
        if let topViewController = missionNavigationController.topViewController as? MissionResultViewController {
            topViewController.navigationController?.popViewController(animated: false)
        }
        // 아닐경우 결과VC 띄움
        let resultViewController = MissionResultViewController(
            coreDataManager: coreDataManager,
            resultId: resultId
        )
        missionNavigationController.pushViewController(resultViewController, animated: true)
    }
}
