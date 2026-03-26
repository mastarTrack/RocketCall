//
//  UIViewController+.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/26/26.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    var viewWillAppear: Observable<Void> {
        methodInvoked(#selector(Base.viewWillAppear(_:))).map { _ in }
    }
    
    var viewDidAppear: Observable<Void> {
        methodInvoked(#selector(Base.viewDidAppear(_:))).map { _ in }
    }
}
