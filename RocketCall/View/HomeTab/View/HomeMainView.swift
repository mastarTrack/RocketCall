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
    let alarmCardView = AlarmCardView()
    let chartView = UIHostingController(rootView: ChartView()).then {
        $0.view.backgroundColor = .cardBackground
        $0.sizingOptions = .intrinsicContentSize
        $0.view.setContentHuggingPriority(UILayoutPriority(249), for: .vertical)
    }
    
    init() {
        super.init(frame: .zero)
        setLayout()
        setAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes() {
        backgroundColor = .background
        
    }
    
    private func setLayout() {
        let titleView = TitleView(title: "항행일지", subTitle: "우주 탐사 대시보드", hasButton: false)
        let alarmCardTitle = UILabel(text: "다가오는 알람", config: .homeViewHeader)
        
        let chartViewTitle = UILabel(text: "주간 기록", config: .homeViewHeader)
        
        let totalTimeCardView = SmallCardView(type: .totalTime)
        let missionCardView = SmallCardView(type: .totalCount)
        
        let smallCardStackView = UIStackView(arrangedSubviews: [totalTimeCardView, missionCardView]).then {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.distribution = .fillEqually
        }
        
        addSubview(titleView)
        addSubview(alarmCardTitle)
        addSubview(alarmCardView)
        addSubview(chartViewTitle)
        addSubview(chartView.view)
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
        
        chartView.view.snp.makeConstraints {
            $0.top.equalTo(chartViewTitle.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(255).priority(.low)
        }
        
        smallCardStackView.snp.makeConstraints {
            $0.top.equalTo(chartView.view.snp.bottom).offset(10)
            $0.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
}

extension HomeMainView {
    
}
