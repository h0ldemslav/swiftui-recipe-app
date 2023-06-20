//
//  APIRepositoryManager.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 19.06.2023.
//

import Foundation

class APIRepositoryManager: APIRepository {
    private let apiManager: APIManager = APIManager()
    static let shared = APIRepositoryManager()
    
    func getRecipeData(query: [String: String]) async throws -> [RecipeData] {
        guard let infoDictionary: [String: Any] = Bundle.main.infoDictionary else { return [] }
        guard let appID: String = infoDictionary["App Api ID"] as? String else { return [] }
        guard let appKey: String = infoDictionary["App Api Keys"] as? String else { return [] }

        var recipes: [RecipeData] = []
        let recipesURLAddress = URL(string: "https://api.edamam.com/api/recipes/v2")

        if var url = recipesURLAddress {
            url = url.appending(queryItems: [
                    URLQueryItem(name: "type", value: "public"),
                    URLQueryItem(name: "app_id", value: appID),
                    URLQueryItem(name: "app_key", value: appKey),
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
                        
                    
                        var digest: [String: Double] = [:]

                        recipe.digest?.forEach({ digestEntry in
                            
                            if digestEntry.label != nil && digestEntry.total != nil {
                                digest[digestEntry.label!] = digestEntry.total!
                            }
                            
                        })
                        
                        recipes.append(RecipeData(
                                id: nil,
                                name: recipe.label ?? "",
                                ingredients: ingredients ?? [],
                                instructions: recipe.url ?? "", // API doesn't provide instructions, so instead here will be stored a link to the recipe instr.
                                calories: recipe.calories,
                                healthLabels: recipe.healthLabels,
                                digestData: digest,
                                imageURL: recipe.image,
                                uri: recipe.uri
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

    func filterNutrientValuesInDigest(isMainNutrient: Bool, digestData: [String: Double]) -> [String: Double] {
        let mainNutrient: (String) -> Bool = { $0 == "Fat" || $0 == "Carbs" || $0 == "Protein"}
        let secondaryNutrient: (String) -> Bool = { ["Cholesterol", "Sodium", "Calcium", "Magnesium", "Potassium", "Iron"].contains($0) }
        
        if isMainNutrient {
            return digestData.filter { mainNutrient($0.key) }
        } else {
            return digestData.filter { secondaryNutrient($0.key) }
        }
    }
}
