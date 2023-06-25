//
//  RecipeDetailView.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 31.05.2023.
//

import SwiftUI
import Charts

struct RecipeDetailView: View {
    @Binding var recipe: RecipeData
    @Binding var recipeType: RecipeType
    @Binding var isDetailPresented: Bool
    @State var isAddEditRecipePresented: Bool = false
    
    @ObservedObject var viewModel: RecipesViewModel
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                
                VStack(alignment: .leading) {
                    
                    VStack(alignment: .center) {
                        if let image = recipe.image {
                            
                            Image(uiImage: image)
                                .resizable()
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
                    }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 8)
                    
                    if let healthLabels = recipe.healthLabels {
                        Text("Health Labels")
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 8)
                        
                        Text(healthLabels.joined(separator: ", "))
                            .padding(.bottom, 8)
                    }
                    
                    Text("Ingredients")
                        .font(.title2)
                        .bold()
                        .padding(.bottom, 8)
                    
                    ForEach(recipe.ingredients, id: \.self) { ingredient in
                        Text("• \(ingredient.name) - \(ingredient.quantity)")
                            .padding(.leading, 5)
                            .padding(.bottom, 3)
                    }
                

                    Text("Instructions")
                        .font(.title2)
                        .bold()
                        .padding(.bottom, 8)
                        .padding(.top, 12)
                    
                    if recipe.instructions.starts(with: "http") {
                        
                        if let url = URL(string: recipe.instructions) {
                            Link("Recipe instructions (external web page)", destination: url)
                                .padding(.bottom, 12)
                        } else {
                            Text("No instructions available")
                                .padding(.bottom, 12)
                        }
                        
                    } else {
                        Text(recipe.instructions)
                            .padding(.bottom, 12)
                    }
                    
                    if let digest = recipe.digestData {
                        let secondaryNutrients = APIRepositoryManager.shared.filterNutrientValuesInDigest(isMainNutrient: false, digestData: digest)
                        let mainNutrients = APIRepositoryManager.shared.filterNutrientValuesInDigest(isMainNutrient: true, digestData: digest)

                        Text("Details")
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 8)

                        Chart {
                            ForEach(Array(secondaryNutrients.keys), id: \.self) { key in
                                BarMark(
                                    x: .value("Name", key),
                                    y: .value("Amount", secondaryNutrients[key]!)
                                )
                                    .foregroundStyle(by: .value("Name", key))
                            }
                        }
                            .frame(height: 400)
                        
                        Text("In milligrams")
                            .padding(.bottom, 30)

                        Chart {
                            ForEach(Array(mainNutrients.keys), id: \.self) { key in
                                BarMark(x: .value(key, mainNutrients[key]!))
                                    .foregroundStyle(by: .value("Name", key))
                            }
                        }
                            .frame(height: 100)
                        
                        Text("In grams")
                    }
                    
                }
                    .padding(.horizontal)
                
            }
            
            .navigationTitle(recipe.name)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if recipe.id == nil && !viewModel.containsApiRecipeData(recipe) {
                        // Recipe that comes from API
                        
                        Button("Add to recipes") {
                            if let uri = recipe.uri {
                                viewModel.addRecipeFromApi(name: recipe.name, uri: uri)
                            }
                        }
                        
                    } else if recipe.id != nil && recipe.uri == nil {
                        Button("Edit") {
                            isAddEditRecipePresented = true
                        }
                    }
                }
                
                if recipe.id != nil || viewModel.containsApiRecipeData(recipe) {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Delete") {
                            viewModel.deleteRecipe(recipeType, recipe: recipe)
                            isDetailPresented = false
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
