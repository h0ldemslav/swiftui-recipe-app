//
//  SearchResultView.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 29.05.2023.
//

import SwiftUI

struct SearchResultView: View {
    @ObservedObject var viewModel: SearchViewModel
    @ObservedObject var recipesViewModel: RecipesViewModel
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var recipe: SearchRecipe
    @Binding var isPresented: Bool
    @Binding var recipes: [RecipeData]
    
    @State var currentRecipe: RecipeData = RecipeData(id: nil, name: "", ingredients: [], instructions: "")
    @State var isDetailPresented: Bool = false
    @State var isErrorPresented: Bool = false
    @State var isPaginatingProgressViewVisible: Bool = false
    @State private var recipeType: RecipeType = .ApiRecipe

    var body: some View {
        NavigationView {

                ScrollView {
                    
                    LazyVStack {
                        HStack {
                            TextField("", text: $recipe.name)
                                .padding(.leading, 30)
                                .overlay(
                                    Image(systemName: "magnifyingglass"),
                                    alignment: .leading
                                )
                                .onSubmit {
                                    var query: [String: String] = [
                                        "q": recipe.name,
                                        "mealType": recipe.selectedTypeOfMeal.rawValue,
                                        "calories": "\(recipe.caloriesStart)-\(recipe.caloriesEnd)"
                                    ]
                                    
                                    if recipe.selectedDiet != .None {
                                        query.updateValue(recipe.selectedDiet.rawValue, forKey: "diet")
                                    }
                                    
                                    recipes = []

                                    Task { recipes = await viewModel.getAllRecipes(query: query) }
                                }
                        }
                        .padding(10)
                        .background(colorScheme == .dark ? Color(#colorLiteral(red: 0.108350046, green: 0.1083115861, blue: 0.1192783192, alpha: 1)) : Color(#colorLiteral(red: 0.9490494132, green: 0.9489870667, blue: 0.9673765302, alpha: 1)))
                        .cornerRadius(10)
                        .padding(.horizontal, 8)
                        .padding(.bottom, 20)
                        
                        ForEach(recipes, id: \.self) { recipe in
                            HStack {
                                if let imageURL = recipe.imageURL {
                                    AsyncImage(url: URL(string: imageURL)) { image in
                                        image.resizable()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.gray, lineWidth: 1)
                                        )
                                        .frame(maxWidth: 120, maxHeight: 120)
                                        .padding(.leading, 15)
                                        .padding(.bottom, 5)
                                }
                                
                                VStack(alignment: .leading) {
                                    
                                    Text(recipe.name)
                                        .padding(.bottom, 0.5)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .lineLimit(1)
                                    
                                    if let healthLabels = recipe.healthLabels {
                                        Text(healthLabels.joined(separator: " • "))
                                            .font(.subheadline)
                                            .lineLimit(4)
                                    } else {
                                        Text("No health labels")
                                            .font(.subheadline)

                                        Spacer()
                                    }

                                    Button(action: {
                                        currentRecipe = recipe
                                        isDetailPresented = true
                                    }, label: {
                                        HStack {
                                            Text("Read")
                                                .font(.callout)
                                                .fontWeight(.semibold)
                                                .padding(.vertical, 1)
                                            
                                            Spacer()
                                            
                                            Image("EdamamAttributionSmall")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 30)
                                        }
                                    })
                                    
                                }
                                .padding(.horizontal)
                            }
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(colorScheme == .dark ? Color(#colorLiteral(red: 0.108350046, green: 0.1083115861, blue: 0.1192783192, alpha: 1)) : Color(#colorLiteral(red: 0.9490494132, green: 0.9489870667, blue: 0.9673765302, alpha: 1)))
                            )
                            .padding(.horizontal, 5)
                            .padding(.bottom, 20)
                        }
                        
                        if !viewModel.placeholder.text.isEmpty && !viewModel.placeholder.imageAssetName.isEmpty {
                            BasicErrorView(text: $viewModel.placeholder.text, imageAssetName: $viewModel.placeholder.imageAssetName)
                        } else if recipes == [] {
                            ProgressView()
                        }
                        
                        if viewModel.paginationState == .Paginating {
                            HStack {
                                if isPaginatingProgressViewVisible {
                                    ProgressView()
                                        .padding(.trailing, 4)
                                }
                                
                                Button("Load more") {
                                    isPaginatingProgressViewVisible = true
                                    
                                    Task {
                                        let newRecipes = await viewModel.getNextPage()
                                        
                                        isPaginatingProgressViewVisible = false
                                        
                                        recipes.append(contentsOf: newRecipes)
                                    }
                                }
                                .disabled(isPaginatingProgressViewVisible)
                            }
                            
                        } else if viewModel.paginationState == .EndOfPagination {
                            Text("End of search results")
                        }
                        
                    }
                    .padding(.horizontal, 5)
                    .padding(.top, 16)
                
            }
            .navigationTitle("Search results")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isPresented = false
                    } label: {
                        Label("Search", systemImage: "chevron.backward")
                            .labelStyle(.titleAndIcon)
                            .animation(.easeOut, value: isPresented)
                    }

                }
            }
        }
        
        .navigationViewStyle(.stack)
        
        .sheet(isPresented: $isDetailPresented) {
            RecipeDetailView(
                recipe: $currentRecipe,
                recipeType: $recipeType,
                isDetailPresented: $isDetailPresented,
                viewModel: recipesViewModel
            )
        }
    }
}
