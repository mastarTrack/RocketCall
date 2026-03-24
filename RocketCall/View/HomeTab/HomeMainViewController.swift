//
//  HomeMainViewController.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/24/26.
//

import UIKit
import SnapKit

class HomeMainViewController: UIViewController {
    let homeMainView = HomeMainView()
    
    override func loadView() {
        view = HomeMainView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
    }
}
