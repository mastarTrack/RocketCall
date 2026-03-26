//
//  Untitled.swift
//  RocketCall
//
//  Created by Hanjuheon on 3/26/26.
//

protocol ViewModelProtocol {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
