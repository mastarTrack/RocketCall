//
//  HomeCollectionHeaderView.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/29/26.
//
import UIKit
import SnapKit
import RxSwift

final class HomeCollectionHeaderView: UICollectionReusableView {
    private(set) var disposeBag = DisposeBag()
    let headerView = HomeHeaderView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(headerView)
        
        headerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag() // 구독 초기화
    }
    
    func configure(title: String, hasButton: Bool, buttonTitle: String = "") {
        headerView.configure(title: title, hasButton: hasButton, buttonTitle: buttonTitle)
    }
}
