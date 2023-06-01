//
//  RecipesRepository.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 01.06.2023.
//

import Foundation
import SwiftUI

protocol RecipesRepository {
    func fetchAllRecipes() -> [RecipeEntity]
    func addNewRecipe(name: String, ingredients: String, instructions: String, image: UIImage?)
    func addRecipeFromApi(name: String, uri: String)
    func deleteRecipe(recipe: RecipeEntity)
}
