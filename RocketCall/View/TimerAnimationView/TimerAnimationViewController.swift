//
//  TimerAnimationViewController.swift
//  RocketCall
//
//  Created by Yeseul Jang on 3/25/26.
//

import UIKit
import SnapKit

final class TimerAnimationViewController: UIViewController {
    private let timerAnimationView = TimerAnimationView()
    private let timerView = TimerAnimationBottomView()
    private var progressTimer: Timer?
    
    // 샘플데이터
    private let sampleTotalDuration: TimeInterval = 2 * 60
    private var sampleRemainingTime: TimeInterval = 2 * 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupLayout()
        
        // 현재 상태를 업데이트 해줌(초기값 전달)
        timerAnimationView.updatePlanetProgress(
            remainingTime: sampleRemainingTime,
            totalDuration: sampleTotalDuration
        )
    }
    
    // 백그라운드로 가면 멈춤고 시작하는 로직
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startSampleProgressTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopSampleProgressTimer()
    }
    
    private func configureUI() {
        view.backgroundColor = .background
        view.addSubview(timerAnimationView)
        view.addSubview(timerView)
    }
    
    // 상단은 애니메이션 하단은 타이머
    private func setupLayout() {
        timerAnimationView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(2.0 / 3.0)
        }
        
        timerView.snp.makeConstraints {
            $0.top.equalTo(timerAnimationView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // 타이머 시작 부분
    private func startSampleProgressTimer() {
        stopSampleProgressTimer() // 중복생성 막기
        
        // 진행 타이머
        progressTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self else { return }
            
            // 남은 시간을 줄여줌
            sampleRemainingTime = max(sampleRemainingTime - 1, 0)
            // 남은 시간을 기반으로 행성크기 다시 업데이트
            timerAnimationView.updatePlanetProgress(
                remainingTime: sampleRemainingTime,
                totalDuration: sampleTotalDuration
            )
            // 0이되면 타이머 종료
            if sampleRemainingTime <= 0 {
                timer.invalidate()
            }
        }
    }
    
    // 타이머 정지 로직
    private func stopSampleProgressTimer() {
        progressTimer?.invalidate()
        progressTimer = nil
    }
}
