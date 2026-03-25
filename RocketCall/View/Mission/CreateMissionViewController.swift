//
//  CreateMissionViewController.swift
//  RocketCall
//
//  Created by 손영빈 on 3/25/26.
//

import UIKit

class CreateMissionViewController: UIViewController {
    
    private let mainView = CreateMissionView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
