//
//  HomeDetailViewController.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/27/26.
//

import UIKit

final class HomeDetailViewController: UIViewController {
    let detailView = HomeDetailView()
    
    override func loadView() {
        self.view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}
