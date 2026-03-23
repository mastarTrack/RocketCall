//
//  ViewController.swift
//  RocketCall
//
//  Created by 손영빈 on 3/23/26.
//

import UIKit
import SnapKit

// StateLabel 예시 및 NavigationController 타이틀 설정 예시
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .background
        
        navigationController?.isNavigationBarHidden = true
        let titleView = TitleView(title: "알람", subTitle: "알람을 설정해주세요", hasButton: true)
        
        view.addSubview(titleView)
        
        titleView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(50)
        }
    }
}

