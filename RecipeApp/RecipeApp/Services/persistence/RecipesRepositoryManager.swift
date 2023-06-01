//
//  RecipesRepositoryManager.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 01.06.2023.
//

import Foundation
import SwiftUI
import CoreData

class RecipesRepositoryManager: RecipesRepository {

    private var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    static let shared = RecipesRepositoryManager()
    
    func fetchAllRecipes() -> [RecipeEntity] {
        let request = NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
        var recipes: [RecipeEntity] = []
        
        do {
            try recipes.append(contentsOf: viewContext.fetch(request))
        } catch let error {
            print("Failed fetching data: \(error)")
        }
        
        return recipes
    }
    
    func addNewRecipe(name: String, ingredients: String, instructions: String, image: UIImage?) {
        let recipeEntity = RecipeEntity(context: viewContext)
        
        recipeEntity.name = name
        recipeEntity.ingredients = ingredients
        recipeEntity.instructions = instructions
        recipeEntity.image = image?.pngData()
        
        saveData()
    }
    
    func addRecipeFromApi(name: String, uri: String) {
        let recipeEntity = RecipeEntity(context: viewContext)
        
        recipeEntity.name = name
        recipeEntity.uri = uri
        
        saveData()
    }
    
    func deleteRecipe(recipe: RecipeEntity) {
        viewContext.delete(recipe)
        saveData()
    }
    
    private func saveData() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch let error {
                print("Failed saving data: \(error)")
            }
        }
    }
    
    
}
