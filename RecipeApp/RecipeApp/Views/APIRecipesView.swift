//
//  APIRecipesView.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 26.05.2023.
//

import SwiftUI

struct APIRecipesView: View {
    @State private var recipeType: RecipeType = .ApiRecipe
    
    @ObservedObject var viewModel: RecipesViewModel
    
    var body: some View {
        NavigationView {
            RecipesListView(
                recipeType: $recipeType,
                recipes: $viewModel.apiRecipes,
                viewModel: viewModel
            )
            
            .navigationTitle("Web recipes")
        }
    }
}
