//
//  AddEditIngredientView.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 02.06.2023.
//

import SwiftUI

struct AddEditIngredientView: View {
    
    @Binding var ingredient: IngredientData
    @Binding var recipe: RecipeData
    @Binding var isPresented: Bool
    
    @State var isIngredientEmpty: Bool = false
    
    @ObservedObject var viewModel: RecipesViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("", text: $ingredient.name)
                } header: {
                    Text("Name")
                        .font(.headline)
                }
                
                Section {
                    TextField("", text: $ingredient.quantity)
                } header: {
                    Text("Quantity")
                        .font(.headline)
                }
                
            }
            
            .navigationTitle("Ingredient")
            
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Save") {
                        recipe.ingredients = viewModel.createOrUpdateIngredient(
                            isNewIngredient: isIngredientEmpty,
                            ingredient: ingredient,
                            recipeIngredients: recipe.ingredients
                        )
                        
                        ingredient.name = ""
                        ingredient.quantity = ""
                        isPresented = false
                    }
                }
                
                if let ingredientID = ingredient.id {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button("Delete") {
                            recipe.ingredients = viewModel.deleteIngredientByID(ingredientID: ingredientID, recipeIngredients: recipe.ingredients)
                            isPresented = false
                        }
                    }
                }
            }
        }
        
        .onAppear {
            if ingredient.name.isEmpty && ingredient.quantity.isEmpty {
                isIngredientEmpty = true
            }
        }
        
        .onDisappear {
            ingredient.name = ""
            ingredient.quantity = ""
        }
        
        .navigationViewStyle(.stack)
    }
}
