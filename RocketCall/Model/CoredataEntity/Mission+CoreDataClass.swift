//
//  Mission+CoreDataClass.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/23/26.
//
//

public import Foundation
public import CoreData

public typealias MissionEntityCoreDataClassSet = NSSet

@objc(MissionEntity)
public class MissionEntity: NSManagedObject {
    static let className = "MissionEntity"
    enum keys {
        static let id = "id"
        static let title = "title"
        static let concentrateTime = "concentrateTime"
        static let breakTime = "breakTime"
        static let cycle = "cycle"
    }
}
