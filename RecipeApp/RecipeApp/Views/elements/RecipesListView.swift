//
//  RecipesListView.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 22.06.2023.
//

import SwiftUI

struct RecipesListView: View {
    @State var recipeSearchValue: String = ""
    @State var isDetailRecipePresented: Bool = false
    @Binding var recipeType: RecipeType
    @Binding var recipes: [RecipeData]
    
    @ObservedObject var viewModel: RecipesViewModel
    
    
    var body: some View {        
            Form {
                Section {
                    TextField("Search", text: $recipeSearchValue)
                        .padding(.leading, 32)
                        .cornerRadius(10)
                        .overlay(
                            Image(systemName: "magnifyingglass"),
                            alignment: .leading
                        )
                }
        
                Section {
                    List {
                        ForEach(recipes.indices, id: \.self) { index in
        
                            if recipeSearchValue.isEmpty {
                                RecipeListRow(
                                    currentRecipe: $recipes[index],
                                    isDetailRecipePresented: $isDetailRecipePresented,
                                    viewModel: viewModel
                                )
                            }
        
                            else if recipes[index].name.contains(recipeSearchValue) {
                                RecipeListRow(
                                    currentRecipe: $recipes[index],
                                    isDetailRecipePresented: $isDetailRecipePresented,
                                    viewModel: viewModel
                                )
                            }

                        }
                        
                        .onDelete { indexSet in
                            guard let index = indexSet.first else { return }
                            viewModel.deleteRecipe(recipeType, recipe: recipes[index])
                        }
        
                    }
                }
            }
        
            .sheet(isPresented: $isDetailRecipePresented) {
                RecipeDetailView(
                    recipe: $viewModel.currentRecipe,
                    recipeType: $recipeType,
                    isDetailPresented: $isDetailRecipePresented,
                    viewModel: viewModel
                )
            }
    }
}

struct RecipeListRow: View {
    @Binding var currentRecipe: RecipeData
    @Binding var isDetailRecipePresented: Bool
    
    @ObservedObject var viewModel: RecipesViewModel
    
    var body: some View {
        HStack {
            Text(currentRecipe.name)
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isDetailRecipePresented = true
            viewModel.currentRecipe = currentRecipe
        }
    }
}
