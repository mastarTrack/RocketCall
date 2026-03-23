//
//  MissionResult+CoreDataProperties.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/23/26.
//
//

public import Foundation
public import CoreData


public typealias MissionResultEntityCoreDataPropertiesSet = NSSet

extension MissionResultEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MissionResultEntity> {
        return NSFetchRequest<MissionResultEntity>(entityName: "MissionResultEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var start: Date
    @NSManaged public var end: Date
    @NSManaged public var isCompleted: Bool

}

extension MissionResultEntity : Identifiable {

}
