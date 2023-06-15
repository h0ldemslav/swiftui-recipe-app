//
//  NewRecipeView.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 31.05.2023.
//

import SwiftUI

struct AddEditRecipeView: View {
    
    @Binding var recipe: RecipeData
    @Binding var isNewRecipe: Bool
    @Binding var isPresented: Bool
    
    @State var currentIngredient: IngredientData = IngredientData(id: nil, name: "", quantity: "")
    @State var isAddEditIngredientPresented: Bool = false
    
    @ObservedObject var viewModel: RecipesViewModel

    var body: some View {
        
        NavigationView {
            Form {
                Section {
                    TextField("Dad's lasagna", text: $recipe.name)
                } header: {
                    Text("Name")
                        .font(.headline)
                } footer: {

                }

                Section {
                    List {
                        ForEach(recipe.ingredients) { ingredient in
                            HStack {
                                Text(ingredient.name)
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                currentIngredient = ingredient
                                isAddEditIngredientPresented = true
                            }
                        }

                        Button("Add ingredient") {
                            isAddEditIngredientPresented = true
                        }
                    }
                } header: {
                    Text("Ingredients")
                        .font(.headline)
                }
            }

            .sheet(isPresented: $isAddEditIngredientPresented) {
                AddEditIngredientView(
                    ingredient: $currentIngredient,
                    recipe: $recipe,
                    isPresented: $isAddEditIngredientPresented,
                    viewModel: viewModel
                )
            }

            .navigationTitle("Recipe")

            .toolbar {
                ToolbarItemGroup {
                    Button("Save") {
                        if !isNewRecipe {
                            viewModel.updateRecipe(recipe: recipe)
                        } else {
                            viewModel.addNewRecipe(recipe: recipe)
                            recipe = RecipeData(id: nil, name: "", ingredients: [], instructions: "")
                        }
                        
                        isPresented = false
                    }
                }
            }
        }
    }
}
