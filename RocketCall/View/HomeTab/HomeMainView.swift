//
//  HomeMainView.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/24/26.
//

import UIKit
import SnapKit
import Then

final class HomeMainView: UIView {
    let alarmCardView = AlarmCardView()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .background
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        let titleView = TitleView(title: "항행일지", subTitle: "우주 탐사 대시보드", hasButton: false)
        let alarmCardTitle = UILabel(text: "다가오는 알람", config: .homeViewHeader)
        
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
        
        smallCardStackView.snp.makeConstraints {
            $0.top.equalTo(alarmCardView.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
    
    }
}

extension HomeMainView {
    
}
