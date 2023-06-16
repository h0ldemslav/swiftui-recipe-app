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
    
    func getAllRecipes(query: [String: String]) async throws -> [RecipeData] {
        var recipes: [RecipeData] = []
        let recipesURLAddress = URL(string: "https://api.edamam.com/api/recipes/v2")
        
        if var url = recipesURLAddress {
            url = url.appending(queryItems: [
                    URLQueryItem(name: "type", value: "public"),
                    URLQueryItem(name: "app_id", value: ""),
                    URLQueryItem(name: "app_key", value: ""),
                ] + query.map { URLQueryItem(name: $0.key, value: $0.value) }
            )

            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            do {
                let response: Response = try await apiManager.request(request)
                
                response.hits?.forEach {
                    if let recipe = $0.recipe {
                        let ingredients = recipe.ingredients?.map {
                            let text = $0.text ?? ""
                            let quantity = $0.quantity ?? 0.0
                            
                            return IngredientData(id: nil, name: text, quantity: String(quantity))
                        }

                        
                        recipes.append(RecipeData(
                                id: nil, name: recipe.label ?? "",
                                ingredients: ingredients ?? [],
                                instructions: "",
                                imageURL: recipe.image
                            )
                        )
                    }
                }

                return recipes
                
            } catch {
                print(error)
            }
        }
        
        return []
    }
}
