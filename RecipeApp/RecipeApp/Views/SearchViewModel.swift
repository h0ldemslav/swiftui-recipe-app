//
//  SearchViewModel.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 05.05.2023.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var searchRecipe: SearchRecipe = SearchRecipe()
    
    func getAllRecipes(query: [String: String]) async throws -> [RecipeData] {
        var recipes: [RecipeData] = []
        
        do {
            recipes = try await APIRepositoryManager.shared.getRecipeData(query: query)
        } catch {
            print(error)
        }
        
        return recipes
    }
}
