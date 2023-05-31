//
//  RecipeAppApp.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 03.05.2023.
//

import SwiftUI

@main
struct RecipeAppApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
