//
//  RecipesRepository.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 01.06.2023.
//

import Foundation
import SwiftUI

enum RecipeType {
    case ApiRecipe
    case UserRecipe
}

protocol RecipesRepository {
    func fetchAllRecipes() -> [RecipeData]
    func fetchRecipeEntityByID(with id: UUID) -> RecipeEntity?
    
    func addNewRecipe(recipe: RecipeData)
    func addRecipeFromApi(name: String, id: String)
    func updateRecipe(recipe: RecipeData)
    func deleteRecipe(recipe: RecipeData)
    
    func parseEntityToRecipe(entity: RecipeEntity) -> RecipeData
    func filterRecipesByType(_ type: RecipeType, recipes: [RecipeData]) -> [RecipeData]
}
