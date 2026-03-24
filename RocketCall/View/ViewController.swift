//
//  ViewController.swift
//  RocketCall
//
//  Created by 손영빈 on 3/23/26.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    let test = AlarmRingView(time: "05:00", date: "2026년 5월 3일", title: "기상")
    
    let coreDataManager: CoreDataManager
    
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
        
        view.addSubview(test)
        test.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
 
}

