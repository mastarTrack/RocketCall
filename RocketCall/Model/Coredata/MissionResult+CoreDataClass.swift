//
//  MissionResult+CoreDataClass.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/23/26.
//
//

public import Foundation
public import CoreData

public typealias MissionResultEntityCoreDataClassSet = NSSet

@objc(MissionResultEntity)
public class MissionResultEntity: NSManagedObject {
    static let className = "MissionResultEntity"
    enum keys {
        static let id = "id"
        static let title = "title"
        static let start = "start"
        static let end = "end"
        static let isCompleted = "isCompleted"
    }
}
