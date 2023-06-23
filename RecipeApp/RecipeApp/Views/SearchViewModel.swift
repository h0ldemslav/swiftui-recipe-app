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
            recipes = try await APIRepositoryManager.shared.getAllRecipeData(query: query)
        } catch let error {
            print(error)
        }
        
        return recipes
    }
    
    func getRecipeByURI(uri: String) async throws -> RecipeData? {
        var recipeData: RecipeData? = nil
        
        do {
            recipeData = try await APIRepositoryManager.shared.getRecipeDataByURI(uri: uri)
        } catch let error {
            print(error)
        }
        
        return recipeData
    }
}
