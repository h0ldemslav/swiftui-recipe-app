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
    
    func getAllRecipes(query: [String: String]) async throws -> [Recipe]? {
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
                return response.hits.map { $0.recipe }
            } catch {
                print(error)
            }
        }
        
        return nil
        
    }
}
