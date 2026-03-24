//
//  Payload.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/23/26.
//

//MARK: CoreData 전달용 Payload
// - CoreDataManager에서 소통할 때, CoreDataManager는 Payload 객체로 전달받고 Payload 객체를 반환합니다.
import Foundation

// 알람
struct AlarmPayload {
    var id: UUID
    var title: String
    var hour: Int
    var minute: Int
    var isRepeat: Bool // 알람 반복 여부
    var repeatDay: Int = -1 // 반복 요일, 없을 경우 -1. 기본값은 없으므로 -1 부여
}

// 커스텀 미션 - 뽀모도로
struct MissionPayload {
    var id: UUID
    var title: String
    var concentrateTime: Int // 집중 시간
    var breakTime: Int // 휴식 시간
    var cycle: Int // 사이클 수
}

// 미션 결과 - 뽀모도로
struct MissionResultPayload {
    var id: UUID
    var title: String // Mission.title과 동일값
    var start: Date
    var end: Date
    var studyTime: Int // 공부 시간
    var isCompleted: Bool // 달성 여부
}
