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
    
    private let alarmCardTitle = UILabel(text: "다가오는 알람", config: LabelConfiguration.homeViewHeader)
    let alarmCardView = AlarmCardView()
    
    let chartHeaderView = HomeHeaderView().then {
        $0.configure(title: "주간 기록", hasButton: true, buttonTitle: "상세 보기")
        $0.unitLabel.isHidden = false
    }
    let chartBaseCardView = BaseCardView()
    
    // SwiftUI로 생성된 ChartView를 UIKit에서 사용하기 위한 HostingController
    private(set) var chartHostingController: UIHostingController<ChartView>
    
    let totalTimeCardView = TotalCardView(type: .totalTime)
    let missionCardView = TotalCardView(type: .totalCount)
    
    init(data: WeeklyData) {
        let chartView = ChartView(data: data)
        self.chartHostingController = UIHostingController(rootView: chartView).then {
            $0.view.backgroundColor = .clear
            
            $0.sizingOptions = .intrinsicContentSize
            $0.view.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        }
        super.init(frame: .zero)
        
        backgroundColor = .background
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        let chartViewTitle = generateChartTitleStack()
        let smallCardStackView = UIStackView(arrangedSubviews: [totalTimeCardView, missionCardView]).then {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.distribution = .fillEqually
        }
        
        addSubview(titleView)
        
        addSubview(alarmCardTitle)
        addSubview(alarmCardView)
        
//        addSubview(chartViewTitle)
        addSubview(chartHeaderView)
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
        
//        chartViewTitle.snp.makeConstraints {
//            $0.top.equalTo(alarmCardView.snp.bottom).offset(15)
//            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
//        }
        
        chartHeaderView.snp.makeConstraints {
            $0.top.equalTo(alarmCardView.snp.bottom).offset(5)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        chartBaseCardView.snp.makeConstraints {
//            $0.top.equalTo(chartViewTitle.snp.bottom).offset(10)
//            $0.top.equalTo(chartHeaderView.snp.bottom).offset(10)
            $0.top.equalTo(chartHeaderView.snp.bottom)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        chartHostingController.view.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.horizontalEdges.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(10)
        }
        
        smallCardStackView.snp.makeConstraints {
            $0.top.equalTo(chartBaseCardView.snp.bottom).offset(10)
            $0.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(92)
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
            
            $0.snp.makeConstraints {
                $0.height.equalTo(chartViewTitle.snp.height)
            }
        }
        
        return stackView
    }
}
