//
//  Alarm+CoreDataProperties.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/23/26.
//
//

public import Foundation
public import CoreData


public typealias AlarmEntityCoreDataPropertiesSet = NSSet

extension AlarmEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlarmEntity> {
        return NSFetchRequest<AlarmEntity>(entityName: "AlarmEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var hour: Int16
    @NSManaged public var minute: Int16
    @NSManaged public var isRepeat: Bool
    @NSManaged public var repeatDay: Int16

}

extension AlarmEntity : Identifiable {

}
