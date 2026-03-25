//
//  CreateMissionView.swift
//  RocketCall
//
//  Created by 손영빈 on 3/25/26.
//

import UIKit
import SnapKit

class CreateMissionView: UIView {
    
    private let titleView = TitleView(title: "미션 계획", subTitle: "커스텀 뽀모도로를 설정하세요.", hasButton: false)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttributes()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CreateMissionView {
    private func setAttributes() {
        
    }
    
    private func setLayout() {
        addSubview(titleView)
        
        titleView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}

extension CreateMissionView{
    func createGrid() {
        
    }
}
