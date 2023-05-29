//
//  SearchViewModel.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 05.05.2023.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var searchRecipe: SearchRecipe = SearchRecipe()
    let apiManager = APIManager()
    
    func getAllRecipes(query: [String: String]) async throws -> [_Recipe]? {
        let recipesURLAddress = URL(string: "https://api.edamam.com/api/recipes/v2")
        
        if var url = recipesURLAddress {
            url = url.appending(queryItems: [
                    URLQueryItem(name: "type", value: "public"),
                    URLQueryItem(name: "app_id", value: ""),
                    URLQueryItem(name: "app_key", value: ""),
                ] + query.map { URLQueryItem(name: $0.key, value: $0.value) }
            )

            let request = URLRequest(url: url)

            do {
                let response: Response = try await apiManager.request(request)
                var recipes: [_Recipe] = []
                
                response.hits?.forEach { hit in
                    if let recipe = hit.recipe {
                        recipes.append(_Recipe(
                            label: recipe.label ?? "Unknown recipe",
                            healthLabels: recipe.healthLabels,
                            ingredients: nil,
                            instructions: recipe.instructions,
                            image: recipe.image,
                            source: recipe.source,
                            url: recipe.url,
                            shareAs: recipe.shareAs,
                            dietLabels: recipe.dietLabels,
                            cautions: recipe.cautions,
                            ingredientLines: recipe.ingredientLines,
                            calories: recipe.calories,
                            glycemicIndex: recipe.glycemicIndex,
                            totalCO2Emissions: recipe.totalCO2Emissions,
                            co2EmissionsClass: recipe.co2EmissionsClass,
                            totalWeight: recipe.totalWeight)
                        )
                    
                    }

                }

                
                
                return recipes
                
            } catch {
                print(error)
            }
        }
        
        return nil
        
    }
}
