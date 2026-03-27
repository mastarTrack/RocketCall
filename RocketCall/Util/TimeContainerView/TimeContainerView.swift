//
//  TimeContainerView.swift
//  RocketCall
//
//  Created by Yeseul Jang on 3/27/26.
//
import UIKit
import SnapKit
import Then

/*
 
예린님 이렇게 쓰시면 될거 같습니다 👽 (이모지 부분은 생략가능)
 enum TargetPlanet: Int, CaseIterable {
     case moon = 2
     case mars = 10
     case venus = 25
....(생략)
     
     var title: String {
         switch self {
         case .moon: return "달"
         case .mars: return "화성"
         case .venus: return "금성"
....(생략)
         }
     }
     
     var emoji: String {
         switch self {
         case .moon: return "🌙"
         case .mars: return "👽"
         case .venus: return "💫"
...(생략)
         }
     }
 }
// 아이템으로 바꿔주는 함수 넣어서 쓰면 편할거같습니다
 extension TargetPlanet {
     var listItem: InfoListItem {
         InfoListItem(
             title: title,
             value: "\(rawValue)시간",
             emoji: emoji
         )
     }
 }
 
 MARK: 사용시  -----------------------
 
 let items = TargetPlanet.allCases.map { $0.listItem }
 lazy var containerView = TimeContainerView(items: self.items)

 ----------------------------------
 enum 안쓰고 단순히 그리기만 할때 (이모지 넣는 부분은 생략가능합니다)
 let items = [
     ContainerInfoItem(title: "제목 1", value: "1시간", emoji: "😀"),
     ContainerInfoItem(title: "제목 2", value: "2시간", emoji: "😇"),
     ContainerInfoItem(title: "제목 3", value: "3시간", emoji: "🌝")
 ]
 lazy var containerView = TimeContainerView(items: self.items)
 
 */



final class TimeContainerView: BaseCardView {
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
    }
    
    private let items: [ContainerInfoItem]
    
    init(items: [ContainerInfoItem]) {
        self.items = items
        super.init(frame: .zero)
        
        addSubview(stackView)
        
        setLayout()
        setupRows()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 패딩만줌
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(24)
        }
    }
    
    private func setupRows() {
        for (index, item) in items.enumerated() {
            // 막줄만 구분선 지워줌
            let isLast = index == items.count - 1
            let rowView = ContainerRowView(item: item, showsSeparator: !isLast)
            stackView.addArrangedSubview(rowView)
        }
    }
}
