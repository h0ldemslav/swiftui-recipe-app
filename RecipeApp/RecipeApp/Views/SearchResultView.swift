//
//  SearchResultView.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 29.05.2023.
//

import SwiftUI

struct SearchResultView: View {
    @ObservedObject var viewModel: SearchViewModel
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var recipe: SearchRecipe
    @Binding var isPresented: Bool
    
    @Binding var recipes: [RecipeData]?

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
                                    let query: [String: String] = [
                                        "q": recipe.name,
                                        "mealType": recipe.selectedTypeOfMeal.rawValue,
                                        "diet": recipe.selectedDiet.rawValue,
                                        "calories": "\(recipe.caloriesStart)-\(recipe.caloriesEnd)"
                                    ]

                                    Task {
                                        do {
                                            let data = try await viewModel.getAllRecipes(query: query)
                                            recipes = data
                                        } catch {
                                            print(error)
                                        }
                                    }
                                }
                        }
                        .padding(10)
                        .background(colorScheme == .dark ? Color(#colorLiteral(red: 0.108350046, green: 0.1083115861, blue: 0.1192783192, alpha: 1)) : Color(#colorLiteral(red: 0.9490494132, green: 0.9489870667, blue: 0.9673765302, alpha: 1)))
                        .cornerRadius(10)
                        .padding(.horizontal, 8)
                        .padding(.bottom, 35)
                        
                        if let r = recipes {
                            ForEach(r, id: \.self) { recipe in
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
                                            .padding(.leading, 12)
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        
                                        Text(recipe.name)
                                            .padding(.bottom, 2)
                                            .font(.headline)
                                            .fontWeight(.bold)
                                        
                                        Text("High Fiber • Dairy Free • Gluten Free • Wheat Free • Egg Free • Peanut Free • Tree Nut Free • Soy Free • Fish Free • Shellfish Free • Pork Free • Crustacean Free • Celery Free")
                                            .font(.caption2 )
                                        
                                        Button(action: {
                                            
                                        }, label: {
                                            Text("Read")
                                                .font(.callout)
                                                .fontWeight(.semibold)
                                                .padding(.vertical, 1)
                                        })
                                    }
                                    .padding(.horizontal)
                                }
                                .padding(.vertical, 15)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(colorScheme == .dark ? Color(#colorLiteral(red: 0.108350046, green: 0.1083115861, blue: 0.1192783192, alpha: 1)) : Color(#colorLiteral(red: 0.9490494132, green: 0.9489870667, blue: 0.9673765302, alpha: 1)))
                                )
                                .padding(.horizontal, 5)
                                .padding(.bottom, 40)
                            }
                        }
                        
                        if recipes?.count == 0 {
                            if let uiimage = UIImage(named: "undraw_empty") {
                                Image(uiImage: uiimage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200)
                                
                                Text("Oops, nothing was found for your query")
                                    .padding(.top, 4)
                            }
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

    }
}
