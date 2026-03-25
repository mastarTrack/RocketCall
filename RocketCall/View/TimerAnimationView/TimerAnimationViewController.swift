//
//  TimerAnimationViewController.swift
//  RocketCall
//
//  Created by Yeseul Jang on 3/25/26.
//

import UIKit
import SnapKit

final class TimerAnimationViewController: UIViewController {
    private let timerAnimationView = TimerAnimationView()
    private let timerView = TimerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupLayout()
    }
    
    private func configureUI() {
        view.backgroundColor = .background
        view.addSubview(timerAnimationView)
        view.addSubview(timerView)
    }
    
    private func setupLayout() {
        timerAnimationView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(2.0 / 3.0)
        }
        
        timerView.snp.makeConstraints {
            $0.top.equalTo(timerAnimationView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
