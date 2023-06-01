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
    @State var isNewRecipePresented = false
    @State var isDetailRecipePresented = false
    
    @ObservedObject var viewModel: RecipesViewModel

    var body: some View {
        NavigationView {
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
                        ForEach(viewModel.recipes, id: \.self) { recipe in
                            
                            if let label = recipe.name {
                                Text(label)
                                    .onTapGesture {
                                        isDetailRecipePresented = true
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
                        isNewRecipePresented = true
                    }
                }
            }
            
            .sheet(isPresented: $isDetailRecipePresented) {
                RecipeDetailView()
            }
        }
        .sheet(isPresented: $isNewRecipePresented) {
            NewRecipeView(
                isPresented: $isNewRecipePresented,
                viewModel: viewModel
            )
        }
    }
}
