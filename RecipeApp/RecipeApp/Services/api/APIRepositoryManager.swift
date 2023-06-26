//
//  APIRepositoryManager.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 19.06.2023.
//

import Foundation

class APIRepositoryManager: APIRepository {
    private let apiManager: APIManager = APIManager()
    private let appID: String
    private let appKey: String
    private var nextPage = ""
    
    static let shared = APIRepositoryManager()
    
    init() {
        appID = Bundle.main.infoDictionary?["App Api ID"] as? String ?? ""
        appKey = Bundle.main.infoDictionary?["App Api Keys"] as? String ?? ""
        
        if appID.isEmpty || appKey.isEmpty {
            print("Failed to fetch app_id or(and) app_key from Info")
        }
    }
    
    func getAllRecipeData(query: [String: String]) async throws -> [RecipeData] {
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

            let response: Response = try await apiManager.request(request)
                        
            recipes = getRecipeDataFromResponseHits(response)
        }
        
        return recipes
    }
    
    func getRecipeDataByID(id: String) async throws -> RecipeData? {
        var recipeData: RecipeData? = nil
        let recipesURLAddress = URL(string: "https://api.edamam.com/api/recipes/v2/\(id)")
        
        if var url = recipesURLAddress {
            url = url.appending(queryItems: [
                    URLQueryItem(name: "type", value: "public"),
                    URLQueryItem(name: "app_id", value: appID),
                    URLQueryItem(name: "app_key", value: appKey)
                ]
            )

            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let responseHit: Hit = try await apiManager.request(request)
            
            if let recipe = responseHit.recipe {
                recipeData = RecipeData(
                    id: nil,
                    name: "",
                    ingredients: [],
                    instructions: "",
                    calories: nil,
                    healthLabels: nil,
                    digestData: nil,
                    imageURL: "",
                    remoteID: nil
                )
                
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

                recipeData?.name = recipe.label ?? "Unknown recipe"
                recipeData?.ingredients = ingredients ?? []
                recipeData?.instructions = recipe.url ?? ""
                recipeData?.calories = recipe.calories
                recipeData?.healthLabels = recipe.healthLabels
                recipeData?.digestData = digest
                recipeData?.imageURL = recipe.image
                recipeData?.remoteID = recipe.uri?.getIDFromRecipeURI()
            }
                
        }
        
        return recipeData
    }
    
    func getNextPage() async throws -> [RecipeData] {
        var recipes: [RecipeData] = []
        
        if !nextPage.isEmpty {
            
            if let url = URL(string: nextPage) {
                var request = URLRequest(url: url)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let response: Response = try await apiManager.request(request)
                
                recipes = getRecipeDataFromResponseHits(response)
            }
            
        }
        
        return recipes
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
    
    private func getRecipeDataFromResponseHits(_ response: Response) -> [RecipeData] {
        var recipes: [RecipeData] = []
        
        nextPage = response.links?.next?.href ?? ""
        
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
                        remoteID: recipe.uri?.getIDFromRecipeURI()
                    )
                )
            }
        }
        
        return recipes
    }
    
}
