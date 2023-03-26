//
//  CoreDataService.swift
//  CodeBase
//
//  Created by Vladyslav Shkodych on 26.03.2023.
//

import CoreData

protocol DataService {
    
    func create<T>() -> T where T: NSManagedObject
    func fetch<T>(_ request: NSFetchRequest<T>) throws -> [T] where T : NSFetchRequestResult
    func save()
    func delete(_ object: NSManagedObject)
}

final class CoreDataService: DataService {
    
    static let shared: CoreDataService = CoreDataService()
    
    private init() {}
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        let modelName: String = "CoreDataModel"
        guard let url: URL = Bundle.main.url(forResource: modelName, withExtension: "momd"),
              let object: NSManagedObjectModel = NSManagedObjectModel(contentsOf: url),
              var persistentStoreURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: object)
        persistentStoreURL.appendPathComponent(modelName + ".sqlite")
        do {
            _ = try coordinator.addPersistentStore(type: .sqlite, at: persistentStoreURL)
        } catch {
            return nil
        }
        return coordinator
    }()
    
    private lazy var privateContext: NSManagedObjectContext = {
        let context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        return context
    }()
    
    private lazy var mainContext: NSManagedObjectContext = {
        let context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = privateContext
        return context
    }()
    
    func create<T>() -> T where T: NSManagedObject {
        return T(context: mainContext)
    }
    
    func save() {
        guard mainContext.hasChanges || privateContext.hasChanges else { return }
        mainContext.performAndWait {
            do {
                try mainContext.save()
            } catch {
                print(error)
            }
        }
        privateContext.perform { [weak privateContext] in
            do {
                try privateContext?.save()
            } catch {
                print(error)
            }
        }
    }
    
    func delete(_ object: NSManagedObject) {
        mainContext.performAndWait {
            mainContext.delete(object)
        }
    }
    
    func fetch<T>(_ request: NSFetchRequest<T>) throws -> [T] where T : NSFetchRequestResult {
        return try mainContext.performAndWait { return try mainContext.fetch(request) }
    }
}
