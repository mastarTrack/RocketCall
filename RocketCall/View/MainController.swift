//
//  MainController.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/23/26.
//
import UIKit
import SnapKit

class MainController: UITabBarController {
    let coreDataManager = CoreDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        tabBar.tintColor = .mainPoint
        self.view.backgroundColor = .background
    }
}

extension MainController {
    private func configure() {
        let firstVC = UINavigationController(rootViewController: ViewController(coreDataManager: coreDataManager))
        let secondVC = UINavigationController(rootViewController: ViewController(coreDataManager: coreDataManager))
        let thirdVC = UINavigationController(rootViewController: MissionViewController(coreDataManager: coreDataManager))
        let fourthVC = UINavigationController(rootViewController: ViewController(coreDataManager: coreDataManager))
        
        firstVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
        secondVC.tabBarItem = UITabBarItem(title: "알람", image: UIImage(systemName: "alarm"), tag: 1)
        thirdVC.tabBarItem = UITabBarItem(title: "미션", image: UIImage(systemName: "timer"), tag: 2)
        fourthVC.tabBarItem = UITabBarItem(title: "자유항행", image: UIImage(systemName: "stopwatch"), tag: 3)
        
        viewControllers = [firstVC, secondVC, thirdVC, fourthVC]
    }
}
