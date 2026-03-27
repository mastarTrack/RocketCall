//
//  Alarm+CoreDataProperties.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/23/26.
//
//

import Foundation
import CoreData


typealias AlarmEntityCoreDataPropertiesSet = NSSet

extension AlarmEntity {

    @nonobjc class func fetchRequest() -> NSFetchRequest<AlarmEntity> {
        return NSFetchRequest<AlarmEntity>(entityName: "AlarmEntity")
    }

    @NSManaged var id: UUID
    @NSManaged var title: String
    @NSManaged var hour: Int16
    @NSManaged var minute: Int16
    @NSManaged var isRepeat: Bool
    @NSManaged var repeatDays: String
    @NSManaged var isOn: Bool

}

extension AlarmEntity : Identifiable {

}
