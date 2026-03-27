//
//  TargetPlanet.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/27/26.
//

import UIKit

// 목표 행성
enum TargetPlanet: Int, CaseIterable {
    case moon = 0
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
    
    var image: UIImage {
        switch self {
        case .moon: UIImage.star5 // 변경 필요
        case .mars: UIImage.star1
        case .venus: UIImage.star3 // 변경 필요
        case .mercury: UIImage.star3
        case .sun: UIImage.star5
        case .jupiter: UIImage.star2
        case .saturn: UIImage.star4
        case .uranus: UIImage.star6
        case .neptune: UIImage.star6 // 변경 필요
        }
    }
    
    var targetTime: Int {
        switch self {
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
