//
//  APIRepository.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 19.06.2023.
//

import Foundation

protocol APIRepository {
    func getAllRecipeData(query: [String: String]) async throws -> [RecipeData]
    func getRecipeDataByID(id: String) async throws -> RecipeData?
    func filterNutrientValuesInDigest(isMainNutrient: Bool, digestData: [String: Double]) -> [String: Double] // main nutrient == fat, carbs or protein
}
