//
//  MissionResultView.swift
//  RocketCall
//
//  Created by Yeseul Jang on 3/24/26.
//
import UIKit
import SnapKit
import Then
// 원
// 헤더 스택 뷰
// 카드뷰
// 하단 버튼
final class MissionResultView: UIView {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let iconCircleView = CircleContainerView(size: 100)
    
    private let checkImageView = UIImageView().then {
        $0.image = UIImage(systemName: "checkmark")
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFit
    }
    
    private let badgeLabel = UILabel().then {
        $0.text = "✓ 미션 성공"
        $0.textColor = UIColor.systemBlue
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.textAlignment = .center
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "미션 완료!"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 35, weight: .bold)
        $0.textAlignment = .center
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "여정을 성공적으로 완료했습니다"
        $0.textColor = UIColor.lightGray
        $0.font = .systemFont(ofSize: 15, weight: .medium)
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        // 스크롤뷰 추가
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // 헤더 추가
        addSubview(iconCircleView)
        iconCircleView.addSubview(checkImageView)
        addSubview(badgeLabel)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }
    
    private func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        iconCircleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        }
        
        checkImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(40)
        }
        
        badgeLabel.snp.makeConstraints {
            $0.top.equalTo(iconCircleView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(badgeLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
    }
    
}
