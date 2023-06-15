//
//  MyRecipesView.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 26.05.2023.
//

import SwiftUI
import CoreData

struct MyRecipesView: View {
    @State var recipeSearchValue = ""
    @State var isAddEditRecipeViewPresented = false
    @State var isDetailRecipePresented = false
    @State var newRecipe: RecipeData = RecipeData(id: nil, name: "", ingredients: [], instructions: "")
    
    @ObservedObject var viewModel: RecipesViewModel
    
    var body: some View {
        NavigationStack {
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
                        ForEach(viewModel.recipes) { recipe in
                            
                            if recipeSearchValue.isEmpty {
                                HStack {
                                    Text(recipe.name)
                                    Spacer()
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    isDetailRecipePresented = true
                                    viewModel.currentRecipe = recipe
                                    
                                    print("RECIPE_UUID: \(recipe.id)")
                                }
                            }
                            
                            else if recipe.name.contains(recipeSearchValue) {
                                HStack {
                                    Text(recipe.name)
                                    Spacer()
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    isDetailRecipePresented = true
                                    viewModel.currentRecipe = recipe
                                    
                                    print("RECIPE_UUID: \(recipe.id)")
                                }
                            }
                            
                        }
                        
                        .onDelete { indexSet in
                            viewModel.deleteRecipe(indexSet: indexSet)
                        }
                        
                    }
                }
            }
            
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

            .sheet(isPresented: $isDetailRecipePresented) {
                RecipeDetailView(recipe: $viewModel.currentRecipe, viewModel: viewModel)
            }
            
        }
    }
    
}
