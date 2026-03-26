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
    
    let refreshRelay: PublishRelay<Void> = PublishRelay()
    
    override func loadView() {
        view = homeMainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        addChild(homeMainView.chartHostingController) // UIHostingVC와 현재 VC의 생명주기 동기화
        homeMainView.chartHostingController.didMove(toParent: self) // 자식 VC(hostingVC)에게 VC 계층에 추가되었음을 알림
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshRelay.accept(Void())
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
