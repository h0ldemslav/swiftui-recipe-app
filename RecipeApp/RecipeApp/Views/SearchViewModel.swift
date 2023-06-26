//
//  SearchViewModel.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 05.05.2023.
//

import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchRecipe: SearchRecipe = SearchRecipe()
    @Published var placeholder: ErrorPlaceholder = ErrorPlaceholder(text: "", imageAssetName: "")
    @Published private (set) var paginationState: PaginationState = .Idle
    
    func getAllRecipes(query: [String: String]) async -> [RecipeData] {
        paginationState = .Idle
        placeholder.text = ""
        placeholder.imageAssetName = ""
        
        var recipes: [RecipeData] = []
        
        do {
            recipes = try await APIRepositoryManager.shared.getAllRecipeData(query: query)

            if recipes.count == 0 {
                placeholder.text = "No recipe found"
                placeholder.imageAssetName = "undraw_empty"
            } else {
                paginationState = .Paginating
            }
        } catch let error {
            processError(error)
        }
        
        return recipes
    }
    
    func getRecipeByID(id: String) async -> RecipeData? {
        var recipe: RecipeData? = nil

        do {
            recipe = try await APIRepositoryManager.shared.getRecipeDataByID(id: id)
            
            if recipe == nil {
                placeholder.text = "No recipe found"
                placeholder.imageAssetName = "undraw_empty"
            }
        } catch let error {
            processError(error)
        }
        
        return recipe
    }
    
    func getNextPage() async -> [RecipeData] {
        var recipes: [RecipeData] = []
        
        do {
            recipes = try await APIRepositoryManager.shared.getNextPage()
            
            if recipes.count == 0 {
                paginationState = .EndOfPagination
            }

        } catch let error {
            paginationState = .Idle
            processError(error)
        }
        
        return recipes
    }
    
    private func processError(_ e: Error) {
        switch e {
        case APIResponseStatus.NoResponse(let message):
            placeholder.text = message
            placeholder.imageAssetName = "undraw_lost"
            
        case APIResponseStatus.BadRequest(let message):
            placeholder.text = message
            placeholder.imageAssetName = "undraw_void"
        
        case APIResponseStatus.Unauthorized(let message):
            placeholder.text = message
            placeholder.imageAssetName = "undraw_secure_server"
            
        case APIResponseStatus.Forbidden(let message):
            placeholder.text = message
            placeholder.imageAssetName = "undraw_access_denied"
            
        case APIResponseStatus.TooManyRequests(let message):
            placeholder.text = message
            placeholder.imageAssetName = "undraw_time_management"
            
        case APIResponseStatus.ServerUnavailable(let message):
            placeholder.text = message
            placeholder.imageAssetName = "undraw_server_down"
            
        case APIResponseStatus.Other(let message):
            placeholder.text = message
            placeholder.imageAssetName = "undraw_fixing_bugs"
            
        default:
            placeholder.text = e.localizedDescription
            print("Unexpected error: \(e)")
        }
    }
}
