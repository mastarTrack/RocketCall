//
//  Untitled.swift
//  RocketCall
//
//  Created by Hanjuheon on 3/24/26.
//


import UIKit
import RxSwift
import SnapKit
import Then

/// 스탑워치 상단 타이머 관련 뷰
class StopWatchHeaderView: UIView {
    
    //MARK: - Components
    /// 타이머 원형 뷰
    private let mainCircleView = UIView().then {
        $0.layer.cornerRadius = 320 / 2
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.mainPoint.cgColor
        $0.backgroundColor = .clear
    }
    /// 타이머 펄스 애니메이션 뷰
    private let pulseCircleView = UIView().then {
        $0.layer.cornerRadius = 340 / 2
        $0.layer.borderWidth = 4
        $0.layer.borderColor = UIColor.darkGray.cgColor
        $0.backgroundColor = .clear
    }
    /// 타이머 라벨
    private let timerLabel = UILabel(
        text: "00:00.00",
        config: .title
    ).then {
        $0.font = UIFont.systemFont(ofSize: 50, weight: .heavy)
    }
    /// 현재 위치 라벨
    private let currentLocationLabel = UILabel().then {
        $0.text = "현재 위치 확인중..."
        $0.font = .systemFont(ofSize: 18)
        $0.textColor = .mainPoint
    }
    /// 목적지 안내 버튼
    private let locationButton = RectangleButton(
        title: "발사 지점",
        color: .mainPoint
    ).then {
        $0.backgroundColor = .cardBackground
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.darkGray.cgColor
    }
    /// 타이머 시작/일시정지 버튼
    private let startButton = CircleButton(
        size: 64,
        image: UIImage(systemName: "play"),
        tintColor: .mainLabel
    )
    /// 레코드 저장 버튼
    private let recordButton = CircleButton(
        size: 64,
        image: UIImage(systemName: "flag"),
        tintColor: .mainLabel
    ).then {
        $0.backgroundColor = .cardBackground
    }
    /// 초기화 버튼
    private let resetButton = CircleButton(
        size: 64,
        image: UIImage(systemName: "arrow.counterclockwise"),
        tintColor: .mainLabel
    ).then {
        $0.backgroundColor = .cardBackground
    }

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .background
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}


//MARK: - Configure UI
extension StopWatchHeaderView {
    private func configureUI() {
        let mainStack = UIStackView().then {
            $0.axis = .vertical
            $0.distribution = .fillProportionally
            $0.alignment = .center
            $0.spacing = 32
        }
        
        let timerStack = UIStackView().then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .center
            $0.spacing = 10
        }
        
        let buttonStack = UIStackView().then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment  = .center
            $0.spacing = 20
        }

        let timerView = UIView().then {
            $0.backgroundColor = .background
        }
        
        timerStack.addArrangedSubview(timerLabel)
        timerStack.addArrangedSubview(currentLocationLabel)
        timerStack.addArrangedSubview(locationButton)
        mainCircleView.addSubview(timerStack)
        timerView.addSubview(pulseCircleView)
        timerView.addSubview(mainCircleView)
        
        buttonStack.addArrangedSubview(startButton)
        buttonStack.addArrangedSubview(recordButton)
        buttonStack.addArrangedSubview(resetButton)
        
        mainStack.addArrangedSubview(timerView)
        mainStack.addArrangedSubview(buttonStack)
        
        addSubview(mainStack)

        
        mainStack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }
        
        timerStack.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().offset(20)
            $0.trailing.lessThanOrEqualToSuperview().inset(20)
        }
        
        buttonStack.snp.makeConstraints {
            $0.width.equalTo(232)
        }
        
        timerView.snp.makeConstraints {
            $0.width.height.equalTo(340)
        }
        
        pulseCircleView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(340)
        }
        
        mainCircleView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(320)
        }
        
        locationButton.snp.makeConstraints {
            $0.width.equalTo(180)
            $0.height.equalTo(38)
        }
    }
}



@available(iOS 17.0, *)
#Preview {
    StopWatchHeaderView()
}
