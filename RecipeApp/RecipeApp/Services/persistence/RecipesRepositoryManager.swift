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
        
        return entity
    }
    
    func parseEntityToRecipe(entity: RecipeEntity) -> RecipeData {
        var ingredients: [IngredientData] = []
        var uiimage: UIImage?
        
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
        
        if let image = entity.image {
            uiimage = UIImage(data: image)
        }
        
        return RecipeData(
            id: entity.recipe_id ?? UUID(),
            name: entity.name ?? "Unknown recipe",
            ingredients: ingredients,
            instructions: entity.instructions ?? "",
            image: uiimage,
            uri: entity.uri // a uri of the recipe from api; nil in case of user created recipe
        )
    
    }
    
    func filterRecipesByType(_ type: RecipeType, recipes: [RecipeData]) -> [RecipeData] {
        if type == .ApiRecipe {
            return recipes.filter({ $0.uri != nil }) // only recipes from the api must contain uri
        } else {
            return recipes.filter({ $0.uri == nil })
        }
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
        
        recipeEntity.recipe_id = UUID()
        recipeEntity.name = name
        recipeEntity.uri = uri
        
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
