//
//  CoredataManager.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/23/26.
//

//MARK: CoreData Manager
import CoreData

final class CoredataManager {
    //MARK: CoreData 기본 설정
    // - Core Data stack
    private let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "RocketCall")
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    // - Core Data Saving support
    // 변경사항 존재 시 코어데이터 context 저장
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    
    // MARK: Custom 설정
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    enum CoreDataError: Error {
        case saveFailed
        case loadFailed
    }
}

//MARK: Create
extension CoredataManager {
    // 알람 생성 메소드
    func createAlarmEntity(alarm: borrowing AlarmPayload) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: AlarmEntity.className, in: context) else { return }
        
        let newEntity = NSManagedObject(entity: entity, insertInto: context)
        
        newEntity.setValue(alarm.id, forKey: AlarmEntity.keys.id)
        newEntity.setValue(alarm.title, forKey: AlarmEntity.keys.title)
        newEntity.setValue(alarm.hour, forKey: AlarmEntity.keys.hour)
        newEntity.setValue(alarm.minute, forKey: AlarmEntity.keys.minute)
        newEntity.setValue(alarm.isRepeat, forKey: AlarmEntity.keys.isRepeat)
        newEntity.setValue(alarm.repeatDay, forKey: AlarmEntity.keys.repeatDay)
        
        do {
            try context.save()
        } catch {
            throw CoreDataError.saveFailed
        }
    }
    
    // 미션 생성 메소드
    func createMissionEntity(mission: borrowing MissionPayload) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: MissionEntity.className, in: context) else { return }
        
        let newEntity = NSManagedObject(entity: entity, insertInto: context)
        
        newEntity.setValue(mission.id, forKey: MissionEntity.keys.id)
        newEntity.setValue(mission.title, forKey: MissionEntity.keys.title)
        newEntity.setValue(mission.concentrateTime, forKey: MissionEntity.keys.concentrateTime)
        newEntity.setValue(mission.breakTime, forKey: MissionEntity.keys.breakTime)
        newEntity.setValue(mission.cycle, forKey: MissionEntity.keys.cycle)
        
        do {
            try context.save()
        } catch {
            throw CoreDataError.saveFailed
        }
    }
    
    // 미션 결과 생성 메소드
    func createMissionResultEntity(result: borrowing MissionResultPayload) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: MissionResultEntity.className, in: context) else { return }
        
        let newEntity = NSManagedObject(entity: entity, insertInto: context)
        
        newEntity.setValue(result.id, forKey: MissionResultEntity.keys.id)
        newEntity.setValue(result.title, forKey: MissionResultEntity.keys.title)
        newEntity.setValue(result.start, forKey: MissionResultEntity.keys.start)
        newEntity.setValue(result.end, forKey: MissionResultEntity.keys.end)
        newEntity.setValue(result.isCompleted, forKey: MissionResultEntity.keys.isCompleted)
        
        do {
            try context.save()
        } catch {
            throw CoreDataError.saveFailed
        }
    }
    
}

//MARK: Create
extension CoredataManager {
    // 알람 생성 메소드
//    func fetchAlarmEntity(of alarmId: UUID) throws -> AlarmPayload {
////        let request: NSFetchRequest<AlarmEntity> = AlarmEntity.fetchRequest()
////        request.predicate = NSPredicate(format: "\(AlarmEntity.keys.id) == %@", alarmId)
////        do {
////            try context.save()
////        } catch {
////            throw CoreDataError.saveFailed
////        }
//    }
    
    // 미션 생성 메소드
    func loadMissionEntity(mission: borrowing MissionPayload) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: MissionEntity.className, in: context) else { return }
        
        let newEntity = NSManagedObject(entity: entity, insertInto: context)
        
        newEntity.setValue(mission.id, forKey: MissionEntity.keys.id)
        newEntity.setValue(mission.title, forKey: MissionEntity.keys.title)
        newEntity.setValue(mission.concentrateTime, forKey: MissionEntity.keys.concentrateTime)
        newEntity.setValue(mission.breakTime, forKey: MissionEntity.keys.breakTime)
        newEntity.setValue(mission.cycle, forKey: MissionEntity.keys.cycle)
        
        do {
            try context.save()
        } catch {
            throw CoreDataError.saveFailed
        }
    }
    
    // 미션 결과 생성 메소드
    func loadMissionResultEntity(result: borrowing MissionResultPayload) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: MissionResultEntity.className, in: context) else { return }
        
        let newEntity = NSManagedObject(entity: entity, insertInto: context)
        
        newEntity.setValue(result.id, forKey: MissionResultEntity.keys.id)
        newEntity.setValue(result.title, forKey: MissionResultEntity.keys.title)
        newEntity.setValue(result.start, forKey: MissionResultEntity.keys.start)
        newEntity.setValue(result.end, forKey: MissionResultEntity.keys.end)
        newEntity.setValue(result.isCompleted, forKey: MissionResultEntity.keys.isCompleted)
        
        do {
            try context.save()
        } catch {
            throw CoreDataError.saveFailed
        }
    }
    
}
