//
//  TimeProgressView.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/27/26.
//
import UIKit

// 그라디언트 레이어 생성 메서드
extension CAGradientLayer {
    static func gradientLayer(frame: CGRect) -> Self {
        let layer = Self()
        let startColor = UIColor(red: 0.17, green: 0.50, blue: 1.00, alpha: 1.00) // HEX #2B7FFF
        layer.colors = [startColor.cgColor, UIColor.mainPoint.cgColor]
        layer.frame = frame
        return layer
    }
}

class GradientProgressView: UIProgressView {
    let gradientLayer: CAGradientLayer
    
    override init(frame: CGRect) {
        // 그라디언트 레이어 설정
        self.gradientLayer = .gradientLayer(frame: frame)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        super.init(frame: frame)
        
        // 색상 설정
        self.tintColor = .clear // 프로그레스바가 모두 채워졌을 때의 색상 - 사용하지 않으므로 투명 처리
        self.trackTintColor = .clear // 프로그레스바가 모두 채워지지 않았을 때의 색상 - 사용하지 않으므로 투명 처리
        self.backgroundColor = .mainPoint.withAlphaComponent(0.2) // 프로그레스바의 배경 색상
        
        // 그라디언트 레이어 추가
        self.layer.addSublayer(gradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientLayer(progress: self.progress)
    }
}

extension GradientProgressView {
    // 프로그레스바를 나타내는 gradientLayer의 크기 조정
    private func updateGradientLayer(progress: Float) {
        let width = self.bounds.width * CGFloat(progress)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: self.bounds.height)
    }
    
    override func setProgress(_ progress: Float, animated: Bool) {
        updateGradientLayer(progress: progress)
        super.setProgress(progress, animated: animated)
    }
}
