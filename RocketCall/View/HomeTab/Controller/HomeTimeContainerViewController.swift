//
//  HomeTimeContainerViewController.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/29/26.
//

import UIKit
import SnapKit

final class HomeTimeContainerViewController: UIViewController {
    let titleView = TitleView(title: "행성 목록", subTitle: "누적 집중 시간에 따라 다음 행성으로 향합니다", hasButton: false)
    let timeContainer = TimeContainerView(items: Planet.allCases.map { $0.listItem })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        view.addSubview(titleView)
        view.addSubview(timeContainer)
        
        titleView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        timeContainer.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
