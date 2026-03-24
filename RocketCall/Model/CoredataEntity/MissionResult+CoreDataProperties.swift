//
//  MissionResult+CoreDataProperties.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/23/26.
//
//

import Foundation
import CoreData

typealias MissionResultEntityCoreDataPropertiesSet = NSSet

extension MissionResultEntity {

    @nonobjc class func fetchRequest() -> NSFetchRequest<MissionResultEntity> {
        return NSFetchRequest<MissionResultEntity>(entityName: "MissionResultEntity")
    }

    @NSManaged var id: UUID
    @NSManaged var title: String
    @NSManaged var start: Date
    @NSManaged var end: Date
    @NSManaged var studyTime: Int64
    @NSManaged var isCompleted: Bool

}

extension MissionResultEntity : Identifiable {

}
