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

    private let titleView = TitleView(title: "Test", subTitle: "Test", hasButton: true)
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    ViewController()
}
