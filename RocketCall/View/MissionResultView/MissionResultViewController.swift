//
//  MissionResultViewController.swift
//  RocketCall
//
//  Created by Yeseul Jang on 3/25/26.
//
import UIKit
import SnapKit

//결과 화면(MissionResultViewController) 띄울 때 push해서 띄우고
//hidesBottomBarWhenPushed = true로 탭바 숨겨주시면 됩니다
class MissionResultViewController: UIViewController {
    private let coreDataManager: CoreDataManager
    private let resultId: UUID?
    
    let missionResultView = MissionResultView()
    
    // UI 확인을 위한 mock 데이터
    private let samplePayload = MissionResultPayload(
        id: UUID(),
        title: "CS 공부",
        start: Date(timeIntervalSince1970: 1773995228),
        end: Date(timeIntervalSince1970: 1773999428),
        studyTime: 45,
        isCompleted: false
    )
    
    // 코어데이터와 아이디를 받아서 뷰를 그림
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
            $0.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
        missionResultView.homeButton.addTarget(self, action: #selector(handleHomeButtonTap), for: .touchUpInside)
        
        // 여기서 데이터 넣어줌(사용시 샘플 데이터 로직 부분 삭제하시면 됩니다)
        if let resultId {
            do {
                let payload = try coreDataManager.fetchMissionResult(of: resultId)
                missionResultView.configure(with: payload)
            } catch {
                // TODO: 오류 처리 로직 구현
                missionResultView.configure(with: samplePayload)
            }
        } else {
            missionResultView.configure(with: samplePayload)
        }
    }
    
    @objc
    private func handleHomeButtonTap() {
        if let navigationController {
            navigationController.popViewController(animated: true)
            return
        }
        
        dismiss(animated: true)
    }
}
