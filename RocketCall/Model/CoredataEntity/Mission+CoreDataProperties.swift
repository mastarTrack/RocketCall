//
//  Mission+CoreDataProperties.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/23/26.
//
//

import Foundation
import CoreData


typealias MissionEntityCoreDataPropertiesSet = NSSet

extension MissionEntity {

    @nonobjc class func fetchRequest() -> NSFetchRequest<MissionEntity> {
        return NSFetchRequest<MissionEntity>(entityName: "MissionEntity")
    }

    @NSManaged var id: UUID
    @NSManaged var title: String
    @NSManaged var concentrateTime: Int16
    @NSManaged var breakTime: Int16
    @NSManaged var cycle: Int16

}

extension MissionEntity : Identifiable {

}
