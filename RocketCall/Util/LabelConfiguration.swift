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

extension LabelConfiguration {
    
    // 크기: 12~18, 색: subLabel, weight: medium
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
    
    static let sub18 = LabelConfiguration(
        font: .systemFont(ofSize: 18, weight: .medium),
        color: .subLabel,
        lines: 1
    )
    
    // 크기: 18~30, 색: mainLabel, weight: medium/bold
    static let main18 = LabelConfiguration(
        font: .systemFont(ofSize: 18, weight: .medium),
        color: .mainLabel,
        lines: 1
    )
    
    static let main20 = LabelConfiguration(
        font: .systemFont(ofSize: 20, weight: .medium),
        color: .mainLabel,
        lines: 1
    )
    
    static let main22 = LabelConfiguration(
        font: .systemFont(ofSize: 22, weight: .medium),
        color: .mainLabel,
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
    
    static let main18Bold = LabelConfiguration(
        font: .systemFont(ofSize: 18, weight: .bold),
        color: .mainLabel,
        lines: 1
    )
    
    static let main20Bold = LabelConfiguration(
        font: .systemFont(ofSize: 20, weight: .bold),
        color: .mainLabel,
        lines: 1
    )
    
    static let main22Bold = LabelConfiguration(
        font: .systemFont(ofSize: 22, weight: .bold),
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
