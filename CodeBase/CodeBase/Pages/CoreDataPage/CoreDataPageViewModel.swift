//
//  CoreDataPageViewModel.swift
//  CodeBase
//
//  Created by Vladyslav Shkodych on 25.03.2023.
//

import SwiftUI
import CoreData

final class CoreDataPageViewModel: ObservableObject {
    
    @Published var fruits: [FruitEntity] = []
    @Published var text: String = ""
    
    var canSubmit: Bool { return !text.isEmpty }
    
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
    
    func onAppear() {
        fetch()
    }
    
    func addNewFruit() {
        withAnimation {
            let newFruit: FruitEntity = FruitEntity(context: mainContext)
            newFruit.tappedCounter = 0
            newFruit.name = text
            save()
            text = ""
        }
    }
    
    func update(_ fruit: FruitEntity) {
        withAnimation {
            fruit.tappedCounter += 1
            save()
        }
    }
    
    func deleteFruit(at offset: IndexSet) {
        withAnimation {
            offset.map { fruits[$0] }.forEach { fruit in
                mainContext.performAndWait {
                    mainContext.delete(fruit)
                }
            }
            save()
        }
    }
}

private extension CoreDataPageViewModel {
    
    func fetch() {
        let request: NSFetchRequest<FruitEntity> = NSFetchRequest<FruitEntity>(entityName: "FruitEntity")
        mainContext.performAndWait {
            do {
                fruits = try mainContext.fetch(request)
            } catch {
                print(error)
            }
        }
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
        fetch()
    }
}
