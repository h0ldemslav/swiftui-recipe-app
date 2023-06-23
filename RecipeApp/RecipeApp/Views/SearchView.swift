//
//  SearchView.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 05.05.2023.
//

import SwiftUI

struct SearchView: View {
    @StateObject var searchViewModel: SearchViewModel = SearchViewModel()
    @ObservedObject var recipesViewModel: RecipesViewModel
    
    var body: some View {
        NavigationView {
            SearchForm(
                viewModel: searchViewModel,
                recipesViewModel: recipesViewModel,
                recipe: $searchViewModel.searchRecipe
            )
            
            .navigationTitle(Text("Search recipes"))
        }
    }
}

struct SearchForm: View {
    @ObservedObject var viewModel: SearchViewModel
    @ObservedObject var recipesViewModel: RecipesViewModel
    @Binding var recipe: SearchRecipe
    @State var isSearchResultPresented: Bool = false
    @State var recipes: [RecipeData]?

    var body: some View {
        ZStack {
            
            Form {
                Section(content: {
                    TextField("Lasagna", text: $recipe.name)
                }, header: {
                    Text("Name")
                        .font(.headline)
                })
                
                
                Section(content: {
                    Picker("Type", selection: $recipe.selectedTypeOfMeal) {
                        ForEach(_MealType.allCases, id: \.self) { type in
                            Text(type.rawValue)
                        }
                    }
                    
                    Picker("Diet", selection: $recipe.selectedDiet) {
                        ForEach(DietType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized)
                        }
                    }
                    
                    Stepper {
                        Text("Calories: \(recipe.caloriesStart)-\(recipe.caloriesEnd)")
                    } onIncrement: {
                        recipe.incrementCalories()
                    } onDecrement: {
                        recipe.decrementCalories()
                    }
                    
                }, header: {
                    Text("Details")
                        .font(.headline)
                })
            }
            
            VStack {
                Button(action: {
                        var query: [String: String] = [
                            "q": recipe.name,
                            "mealType": recipe.selectedTypeOfMeal.rawValue,
                            "calories": "\(recipe.caloriesStart)-\(recipe.caloriesEnd)"
                        ]
                        
                        if recipe.selectedDiet != .None {
                            query.updateValue(recipe.selectedDiet.rawValue, forKey: "diet")
                        }

                        Task {
                            do {
                                let data = try await viewModel.getAllRecipes(query: query)
                                recipes = data
                            } catch {
                                print(error)
                            }
                        }

                    isSearchResultPresented = true
        
                }, label: {
                    Text("Search")
                        .foregroundColor(.black)
                        .bold()
                        .padding()
                        .padding(.horizontal, 120)
                        .background(
                            recipe.name.isEmpty ? Color(#colorLiteral(red: 0.6973065734, green: 0.6973065734, blue: 0.6973065734, alpha: 1)) : .white
                        )
                        .animation(.easeOut, value: recipe.name.isEmpty)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                })
                .disabled(recipe.name.isEmpty)
                .padding(.top, 60)
                
                Image("EdamamAttributionLarge")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                    .padding(.top, 8)
            }
            .padding(.top, 40)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .fullScreenCover(isPresented: $isSearchResultPresented) {
            SearchResultView(
                viewModel: viewModel,
                recipesViewModel: recipesViewModel,
                recipe: $recipe,
                isPresented: $isSearchResultPresented,
                recipes: $recipes
            )
        }
    }
}
