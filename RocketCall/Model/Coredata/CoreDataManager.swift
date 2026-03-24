//
//  CoredataManager.swift
//  RocketCall
//
//  Created by t2025-m0143 on 3/23/26.
//

//MARK: CoreData Manager
import CoreData

final class CoreDataManager {
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
        case empty
    }
}

//MARK: Create
extension CoreDataManager {
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

//MARK: Read
extension CoreDataManager {
    // 알람 불러오기 메소드
    // - 개별 알람
    func fetchAlarm(of alarmId: UUID) throws -> AlarmPayload {
        let entity = try fetchAlarmEntity(of: alarmId)
        
        return AlarmPayload(
            id: entity.id,
            title: entity.title,
            hour: Int(entity.hour),
            minute: Int(entity.minute),
            isRepeat: entity.isRepeat,
            repeatDay: Int(entity.repeatDay)
        )
    }
    
    // - 모든 알람
    func fetchAllAlarm() throws -> [AlarmPayload] {
        let request: NSFetchRequest<AlarmEntity> = AlarmEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(request)
            guard !entities.isEmpty else { throw CoreDataError.empty }
            
            return entities.reduce(into: [AlarmPayload]()) { arr, entity in
                arr.append(AlarmPayload(
                    id: entity.id,
                    title: entity.title,
                    hour: Int(entity.hour),
                    minute: Int(entity.minute),
                    isRepeat: entity.isRepeat,
                    repeatDay: Int(entity.repeatDay)
                ))
            }
        } catch {
            throw CoreDataError.loadFailed
        }
    }
    
    // 미션 불러오기 메소드
    // - 개별 미션
    func fetchMission(of missionId: UUID) throws -> MissionPayload {
        let entity = try fetchMissionEntity(of: missionId)
        
            return MissionPayload(
                id: entity.id,
                title: entity.title,
                concentrateTime: Int(entity.concentrateTime),
                breakTime: Int(entity.breakTime),
                cycle: Int(entity.cycle)
            )
    }
  
    // - 모든 미션
    func fetchAllMission() throws -> [MissionPayload] {
        let request: NSFetchRequest<MissionEntity> = MissionEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(request)
            guard !entities.isEmpty else { throw CoreDataError.empty }
            
            return entities.reduce(into: [MissionPayload]()) { arr, entity in
                arr.append(MissionPayload(
                    id: entity.id,
                    title: entity.title,
                    concentrateTime: Int(entity.concentrateTime),
                    breakTime: Int(entity.breakTime),
                    cycle: Int(entity.cycle)
                ))
            }
        } catch {
            throw CoreDataError.loadFailed
        }
    }
    
    // 미션 결과 불러오기 메소드
    // - 개별 미션 결과
    func fetchMissionResult(of resultId: UUID) throws -> MissionResultPayload {
        let entity = try fetchMissionResultEntity(of: resultId)
        
        return MissionResultPayload(
            id: entity.id,
            title: entity.title,
            start: entity.start,
            end: entity.end,
            isCompleted: entity.isCompleted
        )
    }
    
    // - 모든 미션 결과
    func fetchAllMissionResult() throws -> [MissionResultPayload] {
        let request: NSFetchRequest<MissionResultEntity> = MissionResultEntity.fetchRequest()
        
        do {
            let entities = try context.fetch(request)
            guard !entities.isEmpty else { throw CoreDataError.empty }
            
            return entities.reduce(into: [MissionResultPayload]()) { arr, entity in
                arr.append(MissionResultPayload(
                    id: entity.id,
                    title: entity.title,
                    start: entity.start,
                    end: entity.end,
                    isCompleted: entity.isCompleted
                ))
            }
        } catch {
            throw CoreDataError.loadFailed
        }
    }
}

//MARK: Update
// - 미션 결과는 수정되면 안되므로 구현하지 않았음
extension CoreDataManager {
    // 알람 업데이트 메소드
    func updateAlarmEntity(of payload: borrowing AlarmPayload) throws {
        let entity = try fetchAlarmEntity(of: payload.id)
        
        entity.id = payload.id
        entity.title = payload.title
        entity.hour = Int16(payload.hour)
        entity.minute = Int16(payload.minute)
        entity.isRepeat = payload.isRepeat
        entity.repeatDay = Int16(payload.repeatDay)
        
        do {
            try context.save()
        } catch {
            throw CoreDataError.saveFailed
        }
    }
    
    // 미션 업데이트 메소드
    func updateMissionEntity(of payload: borrowing MissionPayload) throws {
        let entity = try fetchMissionEntity(of: payload.id)
        
        entity.id = payload.id
        entity.title = payload.title
        entity.concentrateTime = Int16(payload.concentrateTime)
        entity.breakTime = Int16(payload.breakTime)
        entity.cycle = Int16(payload.cycle)
        
        do {
            try context.save()
        } catch {
            throw CoreDataError.saveFailed
        }
    }
}

//MARK: Delete
extension CoreDataManager {
    // 알람 삭제 메소드
    // - 개별 알람 삭제
    func deleteAlarmEntity(of alarmId: UUID) throws {
        let entity = try fetchAlarmEntity(of: alarmId)
        context.delete(entity)
        
        do {
            try context.save()
        } catch {
            throw CoreDataError.saveFailed
        }
    }
    
    // 미션 삭제 메소드
    func deleteMissionEntity(of missionId: UUID) throws {
        let entity = try fetchMissionEntity(of: missionId)
        context.delete(entity)
        
        do {
            try context.save()
        } catch {
            throw CoreDataError.saveFailed
        }
    }
    
    // 미션 삭제 메소드
    func deleteMissionResultEntity(of resultId: UUID) throws {
        let entity = try fetchMissionResultEntity(of: resultId)
        context.delete(entity)
        
        do {
            try context.save()
        } catch {
            throw CoreDataError.saveFailed
        }
    }

}

//MARK: Fetch Entity
extension CoreDataManager {
    private func fetchAlarmEntity(of id: UUID) throws -> AlarmEntity {
        let request: NSFetchRequest<AlarmEntity> = AlarmEntity.fetchRequest()
        request.predicate = NSPredicate(format: "\(AlarmEntity.keys.id) == %@", id as CVarArg)
        request.fetchLimit = 1
        
        do {
            guard let entity = try context.fetch(request).first else { throw CoreDataError.empty }
            return entity
        } catch {
            throw CoreDataError.loadFailed
        }
    }
    
    private func fetchMissionEntity(of id: UUID) throws -> MissionEntity {
        let request: NSFetchRequest<MissionEntity> = MissionEntity.fetchRequest()
        request.predicate = NSPredicate(format: "\(MissionEntity.keys.id) == %@", id as CVarArg)
        request.fetchLimit = 1
        
        do {
            guard let entity = try context.fetch(request).first else { throw CoreDataError.empty }
            return entity
        } catch {
            throw CoreDataError.loadFailed
        }
    }
    
    private func fetchMissionResultEntity(of id: UUID) throws -> MissionResultEntity {
        let request: NSFetchRequest<MissionResultEntity> = MissionResultEntity.fetchRequest()
        request.predicate = NSPredicate(format: "\(MissionResultEntity.keys.id) == %@", id as CVarArg)
        request.fetchLimit = 1
        
        do {
            guard let entity = try context.fetch(request).first else { throw CoreDataError.empty }
            return entity
        } catch {
            throw CoreDataError.loadFailed
        }
    }
}
