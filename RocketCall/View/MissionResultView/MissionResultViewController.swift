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
        
        if let resultId {
            do {
                let payload = try coreDataManager.fetchMissionResult(of: resultId)
                missionResultView.configure(with: payload)
            } catch let error as CoreDataManager.CoreDataError {
                showErrorAlert(for: error)
            } catch {
                showErrorAlert(for: .loadFailed)
            }
        } else {
            showErrorAlert(for: .empty)
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
    
    private func showErrorAlert(for error: CoreDataManager.CoreDataError) {
        let message: String
        
        switch error {
        case .empty:
            message = "결과 데이터를 찾을 수 없습니다."
        case .loadFailed:
            message = "결과 데이터를 불러오지 못했습니다."
        case .descriptionLoadFailed:
            message = "데이터 불러오는 중 문제가 발생했습니다."
        case .saveFailed:
            message = "데이터 저장 중 문제가 발생했습니다."
        }
        
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
            self?.handleHomeButtonTap()
        }))
        present(alert, animated: true)
    }
}
