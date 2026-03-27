//
//  ChartView.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/25/26.
//

import SwiftUI
import Charts
import Combine

class WeeklyData: ObservableObject {
    // 차트에서 사용할 데이터소스 타입
    struct WeeklyResult: Identifiable {
        let id: Int // WeekDay rawValue로 사용
        let weekDay: String
        let studyTime: Int
    }
    
    @Published var weeklyResult: [WeeklyResult] = [] // 변화 시 차트뷰에 자동으로 알림
    
    // weeklyResult 업데이트용 외부 호출 함수
    func newValue(_ rawData: [Int: Int]) {
        weeklyResult = convertToWeeklyResult(from: rawData)
    }
    
    // 딕셔너리 -> 차트 사용 데이터로의 변환 베서드
    private func convertToWeeklyResult(from rawData: [Int: Int]) -> [WeeklyResult] {
        let sorted = rawData.sorted(by: { $0.key < $1.key })
        
        var results = Array(repeating: 0, count: 7)
        
        for data in sorted {
            results[data.key] = data.value
        }
        
        return results.enumerated().reduce(into: [WeeklyResult]()) {
            guard let weekday = WeekDay(rawValue: $1.offset) else { return }
            
            $0.append(
                WeeklyResult(
                id: weekday.rawValue,
                weekDay: weekday.koreanName,
                studyTime: $1.element
            ))
        }
    }
}

struct ChartView: View {
    @ObservedObject var data: WeeklyData // data(WeeklyData)에 변화가 있을 시 자동으로 뷰 갱신
        
    var body: some View {
        Chart {
            ForEach(data.weeklyResult) { result in
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
