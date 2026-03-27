//
//  ContainerInfoItem.swift
//  RocketCall
//
//  Created by Yeseul Jang on 3/27/26.
//
import Foundation

struct ContainerInfoItem {
    let title: String
    let value: String
    let emoji: String?
    
    init(title: String, value: String, emoji: String? = nil) {
        self.title = title
        self.value = value
        self.emoji = emoji
    }
}
