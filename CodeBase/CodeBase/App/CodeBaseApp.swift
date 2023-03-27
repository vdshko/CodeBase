//
//  CodeBaseApp.swift
//  CodeBase
//
//  Created by Vladyslav Shkodych on 25.03.2023.
//

import SwiftUI
import DebugFrame

@main
struct CodeBaseApp: App {
    
    var body: some Scene {
        WindowGroup {
            FactoryPages().makeSwinjectPage()
        }
    }
}

private final class FactoryPages {
    
    func makeCoreDataPage() -> CoreDataPage {
        return CoreDataPage()
    }
    
    func makeSwinjectPage() -> SwinjectPage {
        return SwinjectPage()
    }
}
