//
//  MissionResultViewController.swift
//  RocketCall
//
//  Created by Yeseul Jang on 3/25/26.
//
import UIKit
import SnapKit

class MissionResultViewController: UIViewController {
    private let coreDataManager: CoreDataManager
    private let resultId: UUID?
    
    let missionResultView = MissionResultView()
    
    // UI 확인을 위한 mock 데이터
    private let samplePayload = MissionResultPayload(
        id: UUID(),
        title: "CS 공부",
        start: Date(timeIntervalSince1970: 1773995228),
        end: Date(timeIntervalSince1970: 1773996068),
        studyTime: 150,
        isCompleted: false
    )

    init(coreDataManager: CoreDataManager, resultId: UUID? = nil) {
        self.coreDataManager = coreDataManager
        self.resultId = resultId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        view.addSubview(missionResultView)
        missionResultView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        // 여기서 데이터 넣어줌
        if let resultId,
           let payload = try? coreDataManager.fetchMissionResult(of: resultId) {
            missionResultView.configure(with: payload)
        } else {
            missionResultView.configure(with: samplePayload)
        }
    }
}
