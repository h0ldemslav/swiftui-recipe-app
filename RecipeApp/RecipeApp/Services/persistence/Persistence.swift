//
//  Persistence.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 31.05.2023.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "RecipesContainer")
        
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("CORE DATA LOADING ERROR: \(error)")
            }
        }
        
    }
}
