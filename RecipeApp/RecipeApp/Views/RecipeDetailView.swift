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
            
            ScrollView {
                VStack {
                    if let image = recipe.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: 200, height: 200)
                    }
                    
                    if let imageURL = recipe.imageURL {
                        AsyncImage(url: URL(string: imageURL)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .clipShape(Circle())
                        .frame(width: 200, height: 200)
                        
                        Image("EdamamAttributionLarge")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                            .padding(.vertical, 8)
                        
                        Spacer()
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Ingredients")
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 8)
                        ForEach(recipe.ingredients, id: \.self) { ingredient in
                            Text("• \(ingredient.name)")
                                .padding(.leading, 5)
                                .padding(.bottom, 3)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom)
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        Text("Instructions")
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 8)
                        
                        Text(recipe.instructions)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom)
                    .padding(.horizontal)
                    
                }
            }
            
            .navigationTitle(recipe.name)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if recipe.id == nil {
                        Button("Add to recipes") {
                            // TODO: Save to Edamam recipes
                        }
                    } else if recipe.id != nil && recipe.uri == nil {
                        Button("Edit recipe") {
                            isAddEditRecipePresented = true
                        }
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
