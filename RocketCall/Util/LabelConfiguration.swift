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
}
