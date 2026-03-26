//
//  UIViewController+.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/26/26.
//

import UIKit
import RxSwift
import RxCocoa

// ViewController의 메서드를 Observable 객체로 사용할 수 있도록 확장
extension Reactive where Base: UIViewController {
    var viewWillAppear: Observable<Void> {
        methodInvoked(#selector(Base.viewWillAppear(_:))).map { _ in }
    }
    
    var viewDidAppear: Observable<Void> {
        methodInvoked(#selector(Base.viewDidAppear(_:))).map { _ in }
    }
}
