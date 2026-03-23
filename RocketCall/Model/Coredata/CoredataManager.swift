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
}

extension CoredataManager {
    
}
