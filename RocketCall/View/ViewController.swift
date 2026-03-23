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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .background
        
        // 네비게이션 타이틀 위치 조정
        if #available(iOS 17.0, *) {
            navigationItem.largeTitleDisplayMode = .inline
        } else {
            navigationItem.largeTitleDisplayMode = .automatic
        }
    
        // 우측 add 버튼 (+ 버튼)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        title = "알람" // 타이틀 설정
        let subTitle = UILabel(text: "알람을 설정해주세요.", config: LabelConfiguration.subTitle) // 서브 타이틀 설정
        
        // 서브타이틀 레이아웃
        view.addSubview(subTitle)
        subTitle.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-5)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        let stateLabel = StateLabel(text: "완료", config: StateLabelConfiguration.complete)
        
        view.addSubview(stateLabel)
        stateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

