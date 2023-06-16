//
//  NewRecipeView.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 31.05.2023.
//

import SwiftUI

struct AddEditRecipeView: View {
    
    let textEditorPlaceholder = "Type instructions for your recipe"
    
    @Binding var recipe: RecipeData
    @Binding var isNewRecipe: Bool
    @Binding var isPresented: Bool
    
    @State var currentIngredient: IngredientData = IngredientData(id: nil, name: "", quantity: "")
    @State var isAddEditIngredientPresented: Bool = false
    @State var isPickerPresented: Bool = false
    @State var isCameraPresented: Bool = false
    @State var isDialogPresented: Bool = false
    @State var recipeNameError: Bool = false
    
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
                    if recipeNameError {
                        Text("Recipe must at least have a name")
                            .bold()
                            .foregroundColor(.red)
                    }
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
                
                Section {
                    ZStack(alignment: .topLeading) {
                        if recipe.instructions.isEmpty {
                            HStack {
                                Text(textEditorPlaceholder)
                                    .foregroundColor(.gray)
                                    .padding(.top, 8)
                                    .opacity(0.5)
                                Spacer()
                            }
                        }
                        
                        TextEditor(text: $recipe.instructions)
                            .lineLimit(30)
                    }
                    
                } header: {
                    Text("Instructions")
                        .font(.headline)
                }
                
                Section {
                    if let image = recipe.image {
                        HStack {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .frame(width: 150, height: 150)
                        }
                    }
                    
                    Button(recipe.image != nil ? "Change image" : "Add image") {
                        isDialogPresented = true
                    }
                }
            
            header: {
                    Text("Image")
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
            
            .sheet(isPresented: $isPickerPresented) {
                ImagePickerView(sourceType: isCameraPresented ? .camera : .photoLibrary, selectedImage: $recipe.image, isPickerPresented: $isPickerPresented)
            }
            
            .confirmationDialog("Choose the option", isPresented: $isDialogPresented) {
                Button("Select image", action: {
                    isPickerPresented = true
                })
                
                Button("Take a photo", action: {
                    isCameraPresented = true
                    isPickerPresented = true
                })
                
                if recipe.image != nil {
                    Button {
                        recipe.image = nil
                    } label: {
                        Text("Delete")
                            .foregroundColor(.red)
                    }

                }
                
                Button("Cancel", role: .cancel) {}
            }

            .navigationTitle("Recipe")

            .toolbar {
                ToolbarItemGroup {
                    Button("Save") {
                        if !recipe.name.isEmpty {
                            
                            if !isNewRecipe {
                                viewModel.updateRecipe(recipe: recipe)
                            } else {
                                viewModel.addNewRecipe(recipe: recipe)
                                recipe = RecipeData(id: nil, name: "", ingredients: [], instructions: "", image: nil)
                            }
                            
                            isPresented = false
                            
                        } else {
                            recipeNameError = true
                        }
                    }
                }
            }
        }
    }
}
