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
    @Published var currentRecipe: RecipeData = RecipeData(id: nil, name: "", ingredients: [], instructions: "", image: nil)
    
    init() {
        fetchAll()
    }
    
    func addNewRecipe(recipe: RecipeData) {
        RecipesRepositoryManager.shared.addNewRecipe(recipe: recipe)
        fetchAll()
    }
    
    func updateRecipe(recipe: RecipeData) {
        RecipesRepositoryManager.shared.updateRecipe(recipe: recipe)
        fetchAll()
    }
    
    func deleteRecipe(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        RecipesRepositoryManager.shared.deleteRecipe(recipe: recipes[index])
    }
    
    private func fetchAll() {
        recipes = RecipesRepositoryManager.shared.fetchAllRecipes()
    }
    
}
