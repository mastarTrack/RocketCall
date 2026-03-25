//
//  ChartView.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/25/26.
//

import SwiftUI
import Charts

struct MissionResultPayload: Identifiable {
    var id: UUID
    var title: String // Mission.title과 동일값
    var start: Date
    var end: Date
    var studyTime: Int // 공부 시간
    var isCompleted: Bool // 달성 여부
}

struct ChartView: View {

    struct WeeklyResult: Identifiable {
        let id: Int
        let weekDay: Int
        let studyTime: Int
    }
    
    // 날짜 헬퍼
    func date(_ year: Int, _ month: Int, _ day: Int, _ hour: Int, _ minute: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        return Calendar.current.date(from: components)!
    }

    func missionResult() -> [MissionResultPayload] {
        let missionResultSamples: [MissionResultPayload] = [
            // 월요일 - 집중 성공
            MissionResultPayload(
                id: UUID(),
                title: "Swift 문법 정리",
                start: date(2026, 3, 19, 9, 0),
                end: date(2026, 3, 19, 11, 30),
                studyTime: 150, // 2시간 30분
                isCompleted: true
            ),
            // 화요일 - 집중 성공
            MissionResultPayload(
                id: UUID(),
                title: "CoreData 실습",
                start: date(2026, 3, 20, 14, 0),
                end: date(2026, 3, 20, 16, 0),
                studyTime: 120, // 2시간
                isCompleted: true
            ),
            // 수요일 - 중도 포기
            MissionResultPayload(
                id: UUID(),
                title: "네트워크 계층 공부",
                start: date(2026, 3, 21, 10, 0),
                end: date(2026, 3, 21, 10, 45),
                studyTime: 45, // 45분만 하고 포기
                isCompleted: false
            ),
            // 목요일 - 집중 성공
            MissionResultPayload(
                id: UUID(),
                title: "AutoLayout 실습",
                start: date(2026, 3, 22, 13, 0),
                end: date(2026, 3, 22, 15, 30),
                studyTime: 150, // 2시간 30분
                isCompleted: true
            ),
            // 금요일 - 집중 성공 (장시간)
            MissionResultPayload(
                id: UUID(),
                title: "RocketCall UI 구현",
                start: date(2026, 3, 23, 9, 0),
                end: date(2026, 3, 23, 13, 0),
                studyTime: 240, // 4시간
                isCompleted: true
            ),
            // 토요일 - 중도 포기
            MissionResultPayload(
                id: UUID(),
                title: "알고리즘 문제풀이",
                start: date(2026, 3, 24, 11, 0),
                end: date(2026, 3, 24, 11, 30),
                studyTime: 30, // 30분만
                isCompleted: false
            ),
            // 일요일 - 집중 성공
            MissionResultPayload(
                id: UUID(),
                title: "면접 CS 정리",
                start: date(2026, 3, 25, 10, 0),
                end: date(2026, 3, 25, 11, 30),
                studyTime: 90, // 1시간 30분
                isCompleted: true
            )
        ]
        
        return missionResultSamples
    }
    

    
    var body: some View {
        Chart {
            ForEach(missionResult()) { result in
                BarMark( // 바 마크 생성
                    x: .value("요일", Calendar.current.dateComponents(in: .current, from: result.start).weekday!),
                    y: .value("집중 시간", result.studyTime)
                )
                .annotation(position: .top, spacing: 5) {
                    // 바 마크 위에 표시될 값 레이블
                    Text("\(result.studyTime)")
                        .foregroundStyle(Color.mainLabel)
                }
            }
        }
        .chartXAxis { // X축 설정
            AxisMarks(values: .automatic) {
                AxisValueLabel() // X축 값 레이블
                    .foregroundStyle(Color.mainLabel)
                AxisGridLine() // X축 Grid 선
                    .foregroundStyle(Color.subLabel)
            }
        }
        .chartYAxis { // Y축 설정
            AxisMarks(values: .automatic) {
                AxisValueLabel() // Y축 값 레이블
                    .foregroundStyle(Color.mainLabel)
                AxisGridLine() // Y축 Grid 선
                    .foregroundStyle(Color.subLabel)
            }
        }
    }
}
