//
//  MissionViewController.swift
//  RocketCall
//
//  Created by 손영빈 on 3/24/26.
//

import UIKit

class MissionViewController: UIViewController {
    
    private let mainView = MissionView()
    
    let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }
}
