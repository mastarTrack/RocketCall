//
//  LabelConfiguration.swift
//  RocketCall
//
//  Created by Yeseul Jang on 3/23/26.
//
import UIKit

struct LabelConfiguration {
    let font: UIFont
    let color: UIColor
    let lines: Int
}

extension LabelConfiguration {
    static let descriptionTitle = LabelConfiguration(
        font: .boldSystemFont(ofSize: 18),
        color: .darkGray,
        lines: 0
    )
    
    static let descriptionText = LabelConfiguration(
        font: .systemFont(ofSize: 15),
        color: .label,
        lines: 0
    )
    
    static let title = LabelConfiguration(
        font: .systemFont(ofSize: 26, weight: .heavy),
        color: .mainLabel,
        lines: 1
    )
    
    static let subTitle = LabelConfiguration(
        font: .systemFont(ofSize: 14, weight: .medium),
        color: .subLabel,
        lines: 1
    )
    
    static let missionTime = LabelConfiguration(
        font: .systemFont(ofSize: 36),
        color: .mainLabel,
        lines: 1
    )
}

extension LabelConfiguration {
    static let sub12 = LabelConfiguration(
        font: .systemFont(ofSize: 12, weight: .medium),
        color: .subLabel,
        lines: 1
    )
    
    static let sub14 = LabelConfiguration(
        font: .systemFont(ofSize: 14, weight: .medium),
        color: .subLabel,
        lines: 1
    )
    
    static let sub16 = LabelConfiguration(
        font: .systemFont(ofSize: 16, weight: .medium),
        color: .subLabel,
        lines: 1
    )

    static let main24 = LabelConfiguration(
        font: .systemFont(ofSize: 24, weight: .medium),
        color: .mainLabel,
        lines: 1
    )
    
    static let main30 = LabelConfiguration(
        font: .systemFont(ofSize: 30, weight: .medium),
        color: .mainLabel,
        lines: 1
    )

    static let main24Bold = LabelConfiguration(
        font: .systemFont(ofSize: 24, weight: .bold),
        color: .mainLabel,
        lines: 1
    )
    
    static let main30Bold = LabelConfiguration(
        font: .systemFont(ofSize: 30, weight: .bold),
        color: .mainLabel,
        lines: 1
    )
}

/*
 사용예시
 let subLabel = UILabel(config: .sub(size: 12))
 let mainLabel = UILabel(config: .main(size: 24, weight: .bold))
 */
extension LabelConfiguration {
    static func sub(size: CGFloat) -> LabelConfiguration {
        return LabelConfiguration(
            font: .systemFont(ofSize: size, weight: .medium),
            color: .subLabel,
            lines: 1
        )
    }
    
    static func main(size: CGFloat, weight: UIFont.Weight = .medium) -> LabelConfiguration {
        return LabelConfiguration(
            font: .systemFont(ofSize: size, weight: weight),
            color: .mainLabel,
            lines: 1
        )
    }
}
