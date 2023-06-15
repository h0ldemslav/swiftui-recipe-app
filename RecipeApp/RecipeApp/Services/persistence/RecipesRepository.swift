//
//  RecipesRepository.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 01.06.2023.
//

import Foundation
import SwiftUI

protocol RecipesRepository {
    func fetchAllRecipes() -> [RecipeData]
    func fetchRecipeEntityByID(with id: UUID) -> RecipeEntity?
    
    func addNewRecipe(recipe: RecipeData)
    func addRecipeFromApi(name: String, uri: String)
    func updateRecipe(recipe: RecipeData)
    func deleteRecipe(recipe: RecipeData)
    
    func parseEntityToRecipe(entity: RecipeEntity) -> RecipeData
}
