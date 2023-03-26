//
//  FruitEntity+CoreData.swift
//  CodeBase
//
//  Created by Vladyslav Shkodych on 26.03.2023.
//

import CoreData

extension FruitEntity {
    
    static var request: NSFetchRequest<FruitEntity> { return NSFetchRequest<FruitEntity>(entityName: String(describing: self)) }
}
