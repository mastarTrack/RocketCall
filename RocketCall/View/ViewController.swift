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
    let test = MissionResultView()
    let SuccessData = MissionResultData(
        state: true,
        missionName: "성공 미션",
        route: "지구 → 달",
        duration: "00:14",
        type: "계획된 미션",
        statusText: "완료",
        completedDate: "2026. 3. 20. 오후 5:41:08"
    )
    
    let failData = MissionResultData(
        state: false,
        missionName: "실패 미션",
        route: "지구 → 화성",
        duration: "00:08",
        type: "즉시 미션",
        statusText: "실패",
        completedDate: "2026. 3. 25. 오후 9:10:00"
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        view.addSubview(test)
        test.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        test.configure(with: SuccessData)
    }
}

