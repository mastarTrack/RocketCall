//
//  HomeMainView.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/24/26.
//

import UIKit
import SnapKit
import Then
import SwiftUI

final class HomeMainView: UIView {
    //MARK: set attributes
    private let titleView = TitleView(title: "항행일지", subTitle: "우주 탐사 대시보드", hasButton: false)
    
    private let alarmCardTitle = UILabel(text: "다가오는 알람", config: .homeViewHeader)
    private let alarmCardView = AlarmCardView()
    
    private let chartBaseCardView = BaseCardView().then {
        $0.isOn = true
    }
    
    // SwiftUI로 생성된 ChartView를 UIKit에서 사용하기 위한 HostingController
    let chartHostingController = UIHostingController(rootView: ChartView()).then {
        $0.view.backgroundColor = .clear
    }
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .background
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        let chartViewTitle = generateChartTitleStack()
        let smallCardStackView = generateSmallCardStack()
        
        addSubview(titleView)
        
        addSubview(alarmCardTitle)
        addSubview(alarmCardView)
        
        addSubview(chartViewTitle)
        addSubview(chartBaseCardView)
        chartBaseCardView.addSubview(chartHostingController.view)
        
        addSubview(smallCardStackView)
        
        titleView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        alarmCardTitle.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        alarmCardView.snp.makeConstraints {
            $0.top.equalTo(alarmCardTitle.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        chartViewTitle.snp.makeConstraints {
            $0.top.equalTo(alarmCardView.snp.bottom).offset(15)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        chartBaseCardView.snp.makeConstraints {
            $0.top.equalTo(chartViewTitle.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(255).priority(.low) // hugging 우선순위를 낮게 조정
        }
        
        chartHostingController.view.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.horizontalEdges.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        smallCardStackView.snp.makeConstraints {
            $0.top.equalTo(chartBaseCardView.snp.bottom).offset(10)
            $0.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
}

extension HomeMainView {
    private func generateChartTitleStack() -> UIStackView {
        let chartViewTitle = UILabel(text: "주간 기록", config: .homeViewHeader)
        let unitLabel = UILabel().then {
            $0.text = "(단위: 분)"
            $0.textColor = .subLabel
            $0.font = .systemFont(ofSize: 12, weight: .medium)
        }
        
        let stackView = UIStackView(arrangedSubviews: [chartViewTitle, unitLabel]).then {
            $0.axis = .horizontal
            $0.spacing = 5
            $0.alignment = .lastBaseline
            
            chartViewTitle.setContentHuggingPriority(.required, for: .horizontal)
            chartViewTitle.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
        
        return stackView
    }
    
    private func generateSmallCardStack() -> UIStackView {
        let totalTimeCardView = SmallCardView(type: .totalTime)
        let missionCardView = SmallCardView(type: .totalCount)
        
        return UIStackView(arrangedSubviews: [totalTimeCardView, missionCardView]).then {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.distribution = .fillEqually
        }
    }
}
