//
//  AlarmRingView.swift
//  RocketCall
//
//  Created by Yeseul Jang on 3/23/26.
//
import UIKit
import SnapKit
import Then

/*
 생성시 예시
 let alarmView = AlarmRingView(
     time: "07:00",
     date: "3월 23일 월요일",
     title: "기상"
 )
*/

final class AlarmRingView: UIView {
    private let time: String
    private let date: String
    private let title: String
    
    private let circleContainerView = CircleContainerView(size: 180)
    
    private let alarmImageView = UIImageView().then {
        $0.image = UIImage(systemName: "bell")
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFit
    }
    
    let timeLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 90, weight: .ultraLight)
        $0.textAlignment = .center
    }
    
    let dateLabel = UILabel().then {
        $0.textColor = UIColor.subLabel.withAlphaComponent(0.7)
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.textAlignment = .center
    }
    
    private let alarmInfoStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .center
    }
    
    private let dotView = CircleContainerView(size: 12)
    
    let alarmTitleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textAlignment = .center
    }
    
    let stopButton = RectangleButton(title: "중지", color: .mainPoint).then {
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    let snoozeButton = RectangleButton(title: "다시 알림 (5분)", color: .subLabel).then {
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        $0.backgroundColor = UIColor.white.withAlphaComponent(0.1)
    }
    
    private let bottomGuideStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.alignment = .center
    }
    
    private let leftLine = UIView().then {
        $0.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        $0.layer.cornerRadius = 2
    }
    
    let guideLabel = UILabel().then {
        $0.text = "위로 스와이프하여 중지"
        $0.textColor = UIColor.white.withAlphaComponent(0.4)
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textAlignment = .center
    }
    
    private let rightLine = UIView().then {
        $0.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        $0.layer.cornerRadius = 2
    }
    
    init(time: String, date: String, title: String) {
        self.time = time
        self.date = date
        self.title = title
        super.init(frame: .zero)
        
        configureUI()
        setupLayout()
        bindData()
        
        // 앱 상태를 감지하는 부분
        // didBecomeActiveNotification(앱이 다시 활성화 될 때 호출됨)
        // 앱이 켜지면 handleDidBecomeActive를 실행하라고 설정함
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        
        startAnimations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 순환참조를 막는 옵저버 제거 부분
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // 뷰가 화면에 붙고/떨어질때 호출됨 - 화면이 보이는걸 분기로 실행을 나눔
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if window != nil {
            restartAnimations()
        } else {
            stopAnimations()
        }
    }
    
    @objc private func handleDidBecomeActive() {
        restartAnimations()
    }
    
    // 애니메이션은 꼬일 수 있기때문에 멈추고 다시 시작해야함
    private func restartAnimations() {
        stopAnimations()
        startAnimations()
    }
    
    // 현재 가진 애니메이션 강제 종료
    private func stopAnimations() {
        layer.removeAllAnimations()
        circleContainerView.layer.removeAllAnimations()
        alarmImageView.layer.removeAllAnimations()
        
        // .identity(원래상태)로 바꾸어줌
        circleContainerView.transform = .identity
        alarmImageView.transform = .identity
    }
    
    private func bindData() {
        timeLabel.text = time
        dateLabel.text = date
        alarmTitleLabel.text = title
    }
    
    private func configureUI() {
        backgroundColor = UIColor.background
        
        addSubview(circleContainerView)
        circleContainerView.addSubview(alarmImageView)
        
        addSubview(timeLabel)
        addSubview(dateLabel)
        
        addSubview(alarmInfoStackView)
        alarmInfoStackView.addArrangedSubview(dotView)
        alarmInfoStackView.addArrangedSubview(alarmTitleLabel)
        
        addSubview(stopButton)
        addSubview(snoozeButton)
    }
    
    private func setupLayout() {
        circleContainerView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(45)
            $0.centerX.equalToSuperview()
        }
        
        alarmImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(CGSize(width: 90, height: 90))
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(circleContainerView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        alarmInfoStackView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }

        snoozeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-75)
            $0.height.equalTo(65)
        }

        stopButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.bottom.equalTo(snoozeButton.snp.top).offset(-16)
            $0.height.equalTo(65)
        }
    }
}

extension AlarmRingView {
    private func startAnimations() {
        startPulseAnimation()
        startFloatingAnimation()
    }

    private func startPulseAnimation() {
        UIView.animate(
            withDuration: 0.8,
            delay: 0,
            options: [.autoreverse, .repeat, .allowUserInteraction],
            animations: {
                self.circleContainerView.transform = CGAffineTransform(scaleX: 1.06, y: 1.06)
            }
        )
    }
    
    private func startFloatingAnimation() {
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            options: [.autoreverse, .repeat, .allowUserInteraction],
            animations: {
                self.alarmImageView.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
            }
        )
    }
}


