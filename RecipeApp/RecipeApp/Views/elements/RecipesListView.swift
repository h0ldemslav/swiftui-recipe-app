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
    @State var isErrorViewPresented: Bool = false
    @State var isProgressViewVisible: Bool = false
    @Binding var recipeType: RecipeType
    @Binding var recipes: [RecipeData]
    
    @ObservedObject var recipesViewModel: RecipesViewModel
    @StateObject var searchRecipeViewModel: SearchViewModel = SearchViewModel()
    
    var body: some View {
        ZStack {
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
                                    recipeType: $recipeType,
                                    isDetailRecipePresented: $isDetailRecipePresented,
                                    isErrorViewPresented: $isErrorViewPresented,
                                    isProgressViewVisible: $isProgressViewVisible,
                                    recipesViewModel: recipesViewModel,
                                    searchRecipeViewModel: searchRecipeViewModel
                                )
                            }
                            
                            else if recipes[index].name.contains(recipeSearchValue) {
                                RecipeListRow(
                                    currentRecipe: $recipes[index],
                                    recipeType: $recipeType,
                                    isDetailRecipePresented: $isDetailRecipePresented,
                                    isErrorViewPresented: $isErrorViewPresented,
                                    isProgressViewVisible: $isProgressViewVisible,
                                    recipesViewModel: recipesViewModel,
                                    searchRecipeViewModel: searchRecipeViewModel
                                )
                            }
                            
                        }
                        
                        .onDelete { indexSet in
                            guard let index = indexSet.first else { return }
                            recipesViewModel.deleteRecipe(recipeType, recipe: recipes[index])
                        }
                        
                    }
                }
            }
            
            if isProgressViewVisible {
                BasicProgressView(
                    label: "Refreshing data...",
                    textColor: .black,
                    circleTintColor: .black,
                    borderColor: .black,
                    borderWidth: 1,
                    backgroundColor: .white
                )
            }
        }
        
        .sheet(isPresented: $isDetailRecipePresented) {
            RecipeDetailView(
                recipe: $recipesViewModel.currentRecipe,
                recipeType: $recipeType,
                isDetailPresented: $isDetailRecipePresented,
                viewModel: recipesViewModel
            )
        }
        
        .sheet(isPresented: $isErrorViewPresented) {
            BasicErrorViewSheet(
                isPresented: $isErrorViewPresented,
                text: $searchRecipeViewModel.placeholder.text,
                imageAssetName: $searchRecipeViewModel.placeholder.imageAssetName
            )
        }
    }
}

struct RecipeListRow: View {
    @Binding var currentRecipe: RecipeData
    @Binding var recipeType: RecipeType
    @Binding var isDetailRecipePresented: Bool
    @Binding var isErrorViewPresented: Bool
    @Binding var isProgressViewVisible: Bool
    
    @ObservedObject var recipesViewModel: RecipesViewModel
    @ObservedObject var searchRecipeViewModel: SearchViewModel
    
    var body: some View {
        HStack {
            Text(currentRecipe.name)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            
            if recipeType == .ApiRecipe && currentRecipe.uri != nil {
                isProgressViewVisible = true
                
                Task {
                    let data = await searchRecipeViewModel.getRecipeByURI(uri: currentRecipe.uri!)
                    
                    if let recipe = data {
                        recipesViewModel.currentRecipe = recipe
                        isProgressViewVisible = false
                        isDetailRecipePresented = true
                    } else {
                        isProgressViewVisible = false
                        isErrorViewPresented = true
                    }
                    
                }

            } else {
                // recipe comes from the user
                isDetailRecipePresented = true
                recipesViewModel.currentRecipe = currentRecipe
            }
            
        }
        
    }
}
