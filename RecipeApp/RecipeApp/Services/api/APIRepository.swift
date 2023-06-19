//
//  APIRepository.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 19.06.2023.
//

import Foundation

protocol APIRepository {
    func getRecipeData(query: [String: String]) async throws -> [RecipeData]
}
