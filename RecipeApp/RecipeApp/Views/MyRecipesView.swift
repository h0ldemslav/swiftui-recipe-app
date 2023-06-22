//
//  MyRecipesView.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 26.05.2023.
//

import SwiftUI
import CoreData

struct MyRecipesView: View {
    @State private var recipeType: RecipeType = .UserRecipe
    @State var isAddEditRecipeViewPresented = false
    @State var newRecipe: RecipeData = RecipeData(id: nil, name: "", ingredients: [], instructions: "")
    
    @ObservedObject var viewModel: RecipesViewModel
    
    var body: some View {
        NavigationStack {
            RecipesListView(
                recipeType: $recipeType,
                recipes: $viewModel.recipes,
                viewModel: viewModel
            )
            
            .navigationTitle("My recipes")
            
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("New recipe") {
                        isAddEditRecipeViewPresented = true
                    }
                }
            }
            
            .sheet(isPresented: $isAddEditRecipeViewPresented) {
                    AddEditRecipeView(
                        recipe: $newRecipe,
                        isNewRecipe: .constant(true),
                        isPresented: $isAddEditRecipeViewPresented,
                        viewModel: viewModel
                    )
            }
            
        }
    }
    
}
