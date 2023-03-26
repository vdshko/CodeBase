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
    
    private let dataService: DataService
    
    init(dataService: DataService) {
        self.dataService = dataService
    }
    
    func onAppear() {
        fetch()
    }
    
    func addNewFruit() {
        withAnimation {
            let newFruit: FruitEntity = dataService.create()
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
                dataService.delete(fruit)
            }
            save()
        }
    }
}

private extension CoreDataPageViewModel {
    
    func fetch() {
        let request: NSFetchRequest<FruitEntity> = NSFetchRequest<FruitEntity>(entityName: "FruitEntity")
        do {
            fruits = try dataService.fetch(request)
        } catch {
            print(error)
        }
    }
    
    func save() {
        dataService.save()
        fetch()
    }
}
