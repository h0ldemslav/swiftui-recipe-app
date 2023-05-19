//
//  SearchView.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 05.05.2023.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject var searchViewModel: SearchViewModel = SearchViewModel()
    
    var body: some View {
        VStack {
            Text("Search recipes")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 15)
                .padding(.top, 15)
            
            SearchForm(recipe: $searchViewModel.searchRecipe, viewModel: searchViewModel)
        }
    }
}

struct SearchForm: View {
    
    @Binding var recipe: SearchRecipe
    @StateObject var viewModel: SearchViewModel
    
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
                        // TODO: Change calories to range according to Edamam API docs
                        Text("Calories: \(recipe.calories)")
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
                    let query: [String: String] = [
                        "q": recipe.name,
                        "mealType": recipe.selectedTypeOfMeal.rawValue,
                        "diet": recipe.selectedDiet.rawValue,
                        "calories": String(recipe.calories)
                    ]
                    
                    Task {
                        do {
                            let data = try await viewModel.getAllRecipes(query: query)
                            print(data?.first)
                        } catch {
                            print(error)
                        }
                    }

                    
                }, label: {
                    Text("Search")
                        .foregroundColor(.black)
                        .bold()
                        .padding()
                        .padding(.horizontal, 120)
                        .background(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                })
                .padding(.top, 25)
                
                Image("EdamamAttributionLarge")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                    .padding(.top, 8)
                
            }
            .padding(.top, 40)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
