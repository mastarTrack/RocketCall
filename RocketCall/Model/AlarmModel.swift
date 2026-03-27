//
//  AlarmModel.swift
//  RocketCall
//
//  Created by 김주희 on 3/25/26.
//

import Foundation

struct Alarm: Equatable, Identifiable, Hashable {
    let id: UUID
    var hour: Int
    var minute: Int
    var title: String
    var repeatDays: [WeekDay]
    var isOn: Bool
}

enum WeekDay: Int, Equatable, Hashable {
    case mon, tue, wed, thu, fri, sat, sun
}

extension WeekDay {
    var koreanName: String {
        switch self {
        case .mon: return "월"
        case .tue: return "화"
        case .wed: return "수"
        case .thu: return "목"
        case .fri: return "금"
        case .sat: return "토"
        case .sun: return "일"
        }
    }
    
    // 애플 기준 숫자 -> 일~토: 1~7
    var appleWeekDay: Int {
        switch self {
        case .sun: return 1
        case .mon: return 2
        case .tue: return 3
        case .wed: return 4
        case .thu: return 5
        case .fri: return 6
        case .sat: return 7
        }
    }
}
