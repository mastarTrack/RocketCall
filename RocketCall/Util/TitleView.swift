//
//  TitleView.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/23/26.
//

import UIKit
import SnapKit

/// 각 화면의 상단에 타이틀을 표시하는 TitleView입니다.
/// 사용하실 때는 navigationBar를 Hidden 시켜주세요.
/// - Parameters:
///     - title: 화면의 메인 타이틀
///     - subTitle: 화면의 서브 타이틀(부가 설명)
///     - hasButton: addButton 표시 여부
/// - **Example**
///```swift
/// TitleView(
///     title: "알람",
///     subTitle: "알람을 설정해주세요",
///     hasButton: true // addButton 표시 여부
///     )
///
/// // 사용부에서는 navigationBar를 Hidden 시켜주세요
/// navigationController?.isNavigationBarHidden = true
/// ```

class TitleView: UIView {
    let titleLabel: UILabel
    let subTitleLabel: UILabel
    let addButton: UIButton = UIButton(configuration: .plain())
    
    init(title: String, subTitle: String, hasButton: Bool) {
        titleLabel = UILabel(text: title, config: LabelConfiguration.title)
        subTitleLabel = UILabel(text: subTitle, config: LabelConfiguration.subTitle)
        addButton.isHidden = !hasButton
        super.init(frame: .zero)
        
        setAttributes()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TitleView {
    private func setAttributes() {
        backgroundColor = .clear
        
        let symbolConfig = UIImage.SymbolConfiguration(weight: .heavy)
        addButton.setImage(UIImage(systemName: "plus.circle.fill",withConfiguration: symbolConfig), for: .normal)
        addButton.tintColor = .mainPoint
    }
    
    private func setLayout() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .leading
        
        addSubview(stackView)
        addSubview(addButton)
        
        stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.bottom.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(addButton.snp.leading).offset(-10)
        }
        
        addButton.snp.makeConstraints {
            $0.centerY.equalTo(stackView)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(45)
        }
    }
}
