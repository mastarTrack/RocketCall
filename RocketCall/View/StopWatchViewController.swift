//
//  StopWatchViewController.swift
//  RocketCall
//
//  Created by Hanjuheon on 3/24/26.
//

import UIKit
import RxSwift
import SnapKit
import Then

/// StopWatch ViewController
class StopWatchViewController: UIViewController {
    
    //MARK: - ViewModel
    
    //MARK: - Components
    private let titleView = TitleView(
        title: "자유 항행 모드",
        subTitle: "스톱워치 기능으로 원하는 시간까지 카운트하세요.",
        hasButton: false
    )
    
    /// StopWatch 상단 타임 뷰
    private let stopWatchHeaderView = StopWatchHeaderView()
    
    /// StopWatch 하단 레코드 뷰
    private let stopWatchRecordView = StopWatchRecordView()
    
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        //description = "스톱워치 기능으로 원하는 시간까지 카운트하세요."
        view.backgroundColor = .background
        configureUI()
    }
}

//MARK: - Configure UI
extension StopWatchViewController {
    private func configureUI() {
        let mainStack = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 32
            $0.distribution = .fill
            $0.alignment = .fill
        }
        
        mainStack.addArrangedSubview(stopWatchHeaderView)
        mainStack.addArrangedSubview(stopWatchRecordView)
        
        view.addSubview(titleView)
        view.addSubview(mainStack)
        
        titleView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        mainStack.snp.makeConstraints { ms in
            ms.top.equalTo(titleView.snp.bottom)
            ms.leading.equalToSuperview().offset(20)
            ms.trailing.bottom.equalToSuperview().inset(20)
        }

        stopWatchHeaderView.snp.makeConstraints {
            $0.height.equalTo(430)
        }
    }

}

@available(iOS 17.0, *)
#Preview {
    StopWatchViewController()
}
