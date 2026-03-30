//
//  TimerAnimationView.swift
//  RocketCall
//
//  Created by Yeseul Jang on 3/25/26.
//
import UIKit
import SnapKit
import Then

final class TimerAnimationView: UIView {
    private enum Layout {
        static let minimumPlanetSize: CGFloat = 5
        static let maximumPlanetSize: CGFloat = 400
    }
    
    static let availablePlanetImageNames = ["star1", "star2", "star3", "star4", "star5", "star6"]
    
    private let backgroundImageView = UIImageView().then {
        $0.image = UIImage(named: "backGroundImage")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let centerStarImageView = UIImageView().then {
        $0.image = UIImage(named: "star2")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    private let shipImageView = UIImageView().then {
        $0.image = UIImage(named: "spaceShip")
        $0.clipsToBounds = true
    }
    
    private var centerStarWidthConstraint: Constraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPlanetImage(named imageName: String) {
        centerStarImageView.image = UIImage(named: imageName)
    }
    
    // 시간을 기준으로 행성크기 업데이트 로직
    func updatePlanetProgress(remainingTime: TimeInterval, totalDuration: TimeInterval) {
        // 0일 경우가 없도록 함
        guard totalDuration > 0 else {
            // 최소크기를 정함
            centerStarWidthConstraint?.update(offset: Layout.minimumPlanetSize)
            return
        }
        // 남은 시간 전달값 범위를 안전하게 처리 - 0보다 크게, 전체보단 작게
        let remainingTime = min(max(remainingTime, 0), totalDuration)
        // 진행률 계산 (진행률이 1이되면 최대 크기)
        let progress = 1 - (remainingTime / totalDuration)
        // 현재사이즈 = 최소사이즈 + (커져야될 크기) * 진행률
        let currentSize = Layout.minimumPlanetSize + (Layout.maximumPlanetSize - Layout.minimumPlanetSize) * progress
        // 실제로 커지게 하기 - 오토레이아웃은 제약이 바뀌면 맞춰서 뷰를 다시 그림
        centerStarWidthConstraint?.update(offset: currentSize)
    }
    
    private func configureUI() {
        backgroundColor = .background
        
        addSubview(backgroundImageView)
        addSubview(centerStarImageView)
        addSubview(shipImageView)
    }
    
    private func setupLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        centerStarImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            // 일단 초기값으로 초기행성크기를 줌
            centerStarWidthConstraint = $0.width.equalTo(Layout.minimumPlanetSize).constraint
            $0.height.equalTo(centerStarImageView.snp.width)
        }
        
        shipImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// 백그라운드로 갔다가 다시 돌아올때 로직과 우주선 움직임
extension TimerAnimationView {
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if window != nil {
            restartAnimations()
        } else {
            stopAnimations()
        }
    }
    
    private func restartAnimations() {
        stopAnimations()
        startFlyingAnimation()
    }
    
    private func stopAnimations() {
        centerStarImageView.layer.removeAllAnimations()
        shipImageView.layer.removeAllAnimations()
        shipImageView.transform = .identity
    }
    
    // 우주선 위아래 흔들리는 애니메이션
    private func startFlyingAnimation() {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: [.autoreverse, .repeat, .allowUserInteraction],
            animations: {
                self.shipImageView.transform = CGAffineTransform(translationX: 0, y: 3)
            }
        )
    }
}
