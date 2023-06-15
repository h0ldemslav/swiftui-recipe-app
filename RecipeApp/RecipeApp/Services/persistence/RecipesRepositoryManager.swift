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

    private var moc: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    static let shared = RecipesRepositoryManager()
    
    func fetchAllRecipes() -> [RecipeData] {
        let request = NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
        var recipes: [RecipeData] = []
        
        do {
            let objects = try moc.fetch(request)
            recipes.append(contentsOf: objects.map { parseEntityToRecipe(entity: $0) })
        } catch let error {
            print("Failed fetching data: \(error)")
        }
        
        return recipes
    }
    
    func fetchRecipeEntityByID(with id: UUID) -> RecipeEntity? {
        var entity: RecipeEntity?
        
        moc.performAndWait {
            let request = NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
            request.predicate = NSPredicate(format: "recipe_id == %@", id as CVarArg)
            request.fetchLimit = 1
            entity = (try? request.execute())?.first
        }
        
        print("ENTITY_UUID: \(entity?.recipe_id)")
        
        return entity
    }
    
    func parseEntityToRecipe(entity: RecipeEntity) -> RecipeData {
        var ingredients: [IngredientData] = []
        
        if let set = entity.ingredients as? Set<IngredientEntity> {
            ingredients.append(contentsOf:
                                set.map {
                                    IngredientData(
                                        id: $0.ingredient_id ?? UUID(),
                                        name: $0.name ?? "Unknown ingredient",
                                        quantity: $0.quantity ?? ""
                                    )
                                }
                            )
        }
        
        return RecipeData(
            id: entity.recipe_id ?? UUID(),
            name: entity.name ?? "Unknown recipe",
            ingredients: ingredients,
            instructions: entity.instructions ?? ""
        )
    
    }
    
    func addNewRecipe(recipe: RecipeData) {
        let recipeEntity = RecipeEntity(context: moc)
        
        recipeEntity.recipe_id = UUID()
        recipeEntity.name = recipe.name
        recipeEntity.instructions = recipe.instructions
        recipeEntity.image = recipe.image?.pngData()
        
        let ingredients = recipe.ingredients.map {
            let ingredientEntity = IngredientEntity(context: moc)
            
            ingredientEntity.ingredient_id = UUID()
            ingredientEntity.name = $0.name
            ingredientEntity.quantity = $0.quantity
            ingredientEntity.recipes = recipeEntity
            
            return ingredientEntity
        }
        
        recipeEntity.ingredients?.addingObjects(from: ingredients)
        
        saveData()
    }
    
    func updateRecipe(recipe: RecipeData) {
        if let recipe_id = recipe.id {
            
            if let recipeEntity = fetchRecipeEntityByID(with: recipe_id) {
                recipeEntity.name = recipe.name
                
                let ingredients = recipe.ingredients.map {
                    let ingredient = IngredientEntity(context: moc)
                    
                    ingredient.ingredient_id = $0.id
                    ingredient.name = $0.name
                    ingredient.quantity = $0.quantity
                    ingredient.recipes = recipeEntity

                    return ingredient
                }
                
                recipeEntity.ingredients = NSSet(array: ingredients)
                recipeEntity.instructions = recipe.instructions
                recipeEntity.image = recipe.image?.pngData()
                
                saveData()
            }
            
        }
    }
    
    func addRecipeFromApi(name: String, uri: String) {
        let recipeEntity = RecipeEntity(context: moc)
        
        recipeEntity.name = name
        recipeEntity.uri = URL(string: uri)
        
        saveData()
    }
    
    func deleteRecipe(recipe: RecipeData) {
        if let recipe_id = recipe.id {

            if let entity = fetchRecipeEntityByID(with: recipe_id) {
                moc.delete(entity)
                saveData()
            }
        }
        
    }
    
    private func saveData() {
        if moc.hasChanges {
            do {
                try moc.save()
            } catch let error {
                print("Failed saving data: \(error)")
            }
        }
    }
    
}
