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
    
    @Published var recipes: [RecipeEntity] = []
    
    init() {
        fetchAll()
    }
    
    private func fetchAll() {
        recipes = RecipesRepositoryManager.shared.fetchAllRecipes()
    }
    
    func addNewRecipe(name: String, ingredients: String, instructions: String, image: UIImage?) {
        RecipesRepositoryManager.shared.addNewRecipe(name: name, ingredients: ingredients, instructions: instructions, image: image)
        fetchAll()
    }
    
    func deleteRecipe(indexSet: IndexSet) {
        guard let index = indexSet.first else {
            return
        }
        
        RecipesRepositoryManager.shared.deleteRecipe(recipe: recipes[index])
    }
}
