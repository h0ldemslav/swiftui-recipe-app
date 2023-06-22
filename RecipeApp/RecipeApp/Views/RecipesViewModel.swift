//
//  RecipesViewModel.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 01.06.2023.
//

import Foundation
import SwiftUI
import CoreData

class RecipesViewModel: ObservableObject {
    
    @Published var recipes: [RecipeData] = []
    @Published var apiRecipes: [RecipeData] = []
    @Published var currentRecipe: RecipeData = RecipeData(id: nil, name: "", ingredients: [], instructions: "", image: nil)
    
    init() {
        fetchAllRecipes()
    }
    
    func addRecipeFromApi(name: String, uri: String) {
        RecipesRepositoryManager.shared.addRecipeFromApi(name: name, uri: uri)
        fetchAllRecipes()
    }
    
    func addNewRecipe(recipe: RecipeData) {
        RecipesRepositoryManager.shared.addNewRecipe(recipe: recipe)
        fetchAllRecipes()
    }
    
    func updateRecipe(recipe: RecipeData) {
        RecipesRepositoryManager.shared.updateRecipe(recipe: recipe)
        fetchAllRecipes()
    }
    
    func deleteRecipe(_ type: RecipeType, recipe: RecipeData) {
        var recipeData: RecipeData = recipe
        
        if type == .ApiRecipe {
            
            if let index = apiRecipes.firstIndex(where: { $0.uri == recipeData.uri }) {
                recipeData = apiRecipes[index]
                apiRecipes.remove(at: index)
            }
            
        } else if type == .UserRecipe {
            recipes = recipes.filter({ $0.id != recipeData.id })
        }
        
        RecipesRepositoryManager.shared.deleteRecipe(recipe: recipeData)
    }
    
    func containsApiRecipeData(_ recipeData: RecipeData) -> Bool {
        return apiRecipes.contains(where: { $0.uri == recipeData.uri })
    }
    
    private func fetchAllRecipes() {
        let data = RecipesRepositoryManager.shared.fetchAllRecipes()
        recipes = RecipesRepositoryManager.shared.filterRecipesByType(.UserRecipe, recipes: data)
        apiRecipes = RecipesRepositoryManager.shared.filterRecipesByType(.ApiRecipe, recipes: data)
    }

}
