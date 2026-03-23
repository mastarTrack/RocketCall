//
//  MainController.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/23/26.
//
import UIKit
import SnapKit

class MainController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        tabBar.tintColor = .mainPoint
    }
}

extension MainController {
    private func configure() {
        let firstVC = UINavigationController(rootViewController: ViewController())
        let secondVC = UINavigationController(rootViewController: ViewController())
        let thirdVC = UINavigationController(rootViewController: ViewController())
        let fourthVC = UINavigationController(rootViewController: ViewController())
        
        firstVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
        secondVC.tabBarItem = UITabBarItem(title: "알람", image: UIImage(systemName: "alarm"), tag: 1)
        thirdVC.tabBarItem = UITabBarItem(title: "미션", image: UIImage(systemName: "timer"), tag: 2)
        fourthVC.tabBarItem = UITabBarItem(title: "자유항행", image: UIImage(systemName: "stopwatch"), tag: 3)
        
        [firstVC, secondVC, thirdVC, fourthVC].forEach {
            $0.navigationBar.layoutMargins.left = 20
            
            let appearance = UINavigationBarAppearance()
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            
            $0.navigationBar.prefersLargeTitles = true
            $0.navigationBar.standardAppearance = appearance
        }
        
        viewControllers = [firstVC, secondVC, thirdVC, fourthVC]
    }
}
