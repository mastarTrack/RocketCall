//
//  TargetPlanet.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/27/26.
//

import UIKit

// 행성
enum Planet: Int, CaseIterable {
    case earth = 0
    case moon
    case mars
    case venus
    case mercury
    case sun
    case jupiter
    case saturn
    case uranus
    case neptune
    
    var title: String {
        switch self {
        case .earth: "지구"
        case .moon: "달"
        case .mars: "화성"
        case .venus: "금성"
        case .mercury: "수성"
        case .sun: "태양"
        case .jupiter: "목성"
        case .saturn: "토성"
        case .uranus: "천왕성"
        case .neptune: "해왕성"
        }
    }
    var emoji: String {
        switch self {
        case .earth: "🌏"
        case .moon: "🌙"
        case .mars: "🔴"
        case .venus: "🟡"
        case .mercury: "⚪️"
        case .sun: "☀️"
        case .jupiter: "🟤"
        case .saturn: "🪐"
        case .uranus: "🔵"
        case .neptune: "💠"
        }
    }
    
    var targetTime: Int {
        switch self {
        case .earth: 0
        case .moon: 2 // 시간 기준! 달은 2시간
        case .mars: 10 // 10시간
        case .venus: 25 // ...
        case .mercury: 55
        case .sun: 100
        case .jupiter: 250
        case .saturn: 500
        case .uranus: 1000
        case .neptune: 2000
        }
    }
}

extension Planet {
    var listItem: ContainerInfoItem {
        ContainerInfoItem(
            title: title,
            value: "\(targetTime)시간",
            emoji: emoji
        )
    }
}
