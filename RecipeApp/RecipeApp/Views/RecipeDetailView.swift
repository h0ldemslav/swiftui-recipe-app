//
//  RecipeDetailView.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 31.05.2023.
//

import SwiftUI

struct RecipeDetailView: View {
    @Binding var recipe: RecipeData
    @State var isAddEditRecipePresented: Bool = false
    
    @ObservedObject var viewModel: RecipesViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                ForEach(recipe.ingredients) { ingredient in
                    Text(ingredient.name)
                }
                
                Text("Instructions")
                    .font(.title3)
                
                Text(recipe.instructions)
                
            }
            
            .navigationTitle(recipe.name)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit recipe") {
                        isAddEditRecipePresented = true
                    }
                }
            }
        }
        
        .sheet(isPresented: $isAddEditRecipePresented) {
            AddEditRecipeView(
                recipe: $recipe,
                isNewRecipe: .constant(false),
                isPresented: $isAddEditRecipePresented,
                viewModel: viewModel
            )
        }
        
    }
}
