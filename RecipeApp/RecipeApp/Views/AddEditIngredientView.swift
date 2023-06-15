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
                ToolbarItemGroup {
                    Button("Save") {
                        if !isIngredientEmpty {
                            if let index = recipe.ingredients.firstIndex(where: { $0.id == ingredient.id }) {
                                recipe.ingredients[index] = ingredient
                            }
                        } else {
                            let newIngredient = IngredientData(id: UUID(), name: ingredient.name, quantity: ingredient.quantity)
                            recipe.ingredients.append(newIngredient)
                        }
                        
                        ingredient.name = ""
                        ingredient.quantity = ""
                        isPresented = false
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
