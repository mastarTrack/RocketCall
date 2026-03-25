//
//  MissionResult+CoreDataClass.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/23/26.
//
//

import Foundation
import CoreData

typealias MissionResultEntityCoreDataClassSet = NSSet

@objc(MissionResultEntity)
class MissionResultEntity: NSManagedObject {
    static let className = "MissionResultEntity"
    enum keys {
        static let id = "id"
        static let title = "title"
        static let start = "start"
        static let end = "end"
        static let studyTime = "studyTime"
        static let isCompleted = "isCompleted"
    }
}
