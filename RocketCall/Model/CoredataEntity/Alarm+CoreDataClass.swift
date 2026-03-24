//
//  Alarm+CoreDataClass.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/23/26.
//
//

public import Foundation
public import CoreData

public typealias AlarmEntityCoreDataClassSet = NSSet

@objc(AlarmEntity)
public class AlarmEntity: NSManagedObject {
    static let className = "AlarmEntity"
    enum keys {
        static let id = "id"
        static let title = "title"
        static let hour = "hour"
        static let minute = "minute"
        static let isRepeat = "isRepeat"
        static let repeatDay = "repeatDay"
    }
}
