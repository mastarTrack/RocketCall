//
//  Mission+CoreDataProperties.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/23/26.
//
//

public import Foundation
public import CoreData


public typealias MissionEntityCoreDataPropertiesSet = NSSet

extension MissionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MissionEntity> {
        return NSFetchRequest<MissionEntity>(entityName: "MissionEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var concentrateTime: Int16
    @NSManaged public var breakTime: Int16
    @NSManaged public var cycle: Int16

}

extension MissionEntity : Identifiable {

}
