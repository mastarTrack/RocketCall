//
//  MissionViewController.swift
//  RocketCall
//
//  Created by 손영빈 on 3/24/26.
//

import UIKit

class MissionViewController: UIViewController {
    
    private let mainView = MissionView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }
}
