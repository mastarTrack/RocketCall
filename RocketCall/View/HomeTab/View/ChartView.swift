//
//  ChartView.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/25/26.
//

import SwiftUI
import Charts

struct ChartView: View {
    
    struct WeeklyResult: Identifiable {
        let id: Int
        let weekDay: String
        let studyTime: Int
    }
        
    // 목업 데이터
    func missionResult() -> [WeeklyResult] {
        let weeklyResults: [WeeklyResult] = [
            WeeklyResult(id: 0, weekDay: "월", studyTime: 150),
            WeeklyResult(id: 1, weekDay: "화", studyTime: 120),
            WeeklyResult(id: 2, weekDay: "수", studyTime: 45),
            WeeklyResult(id: 3, weekDay: "목", studyTime: 150),
            WeeklyResult(id: 4, weekDay: "금", studyTime: 1000),
            WeeklyResult(id: 5, weekDay: "토", studyTime: 30),
            WeeklyResult(id: 6, weekDay: "일", studyTime: 90)
        ]
        
        return weeklyResults
    }
    
    var body: some View {
        Chart {
            ForEach(missionResult()) { result in
                BarMark( // 바 마크 생성
                    x: .value("요일", result.weekDay),
                    y: .value("집중 시간", result.studyTime),
                    width: .automatic
                )
                .foregroundStyle(Color.mainPoint)
                .annotation(position: .top, spacing: 5) {
                    // 바 마크 위에 표시될 값 레이블
                    Text("\(result.studyTime)")
                        .foregroundStyle(Color.mainLabel)
                        .font(.caption)
                }
                .clipShape(
                    // 바 마크 상단부만 cornerRadius 적용
                    UnevenRoundedRectangle(
                        topLeadingRadius: 4,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 4,
                        style: .circular
                    )
                )
            }
        }
        .chartXAxis { // X축 설정
            AxisMarks(values: .automatic) {
                AxisGridLine() // X축 Grid 선
                    .foregroundStyle(Color.subLabel.opacity(0.5))
                
                AxisValueLabel() // X축 값 레이블
                    .foregroundStyle(Color.mainLabel)
                    .font(.system(size: 12, weight: .medium))
            }
        }
        .chartYAxis { // Y축 설정
            AxisMarks(position: .leading) { value in
                AxisGridLine() // Y축 Grid 선
                    .foregroundStyle(Color.subLabel.opacity(0.5))
                
                AxisValueLabel { // Y축 값 레이블
                    if let minute = value.as(Int.self) {
                        Text("\(minute.formatted(.number))")
                    }
                }
                .foregroundStyle(Color.mainLabel)
                .font(.system(size: 12, weight: .medium))
            }
        }
    }
}
