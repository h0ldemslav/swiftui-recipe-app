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
            
            SearchForm(recipe: $searchViewModel.searchRecipe)
        }
    }
}

struct SearchForm: View {
    
    @Binding var recipe: SearchRecipe
    
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
                        ForEach(MealType.allCases, id: \.self) { type in
                            Text(type.rawValue)
                        }
                    }
                    
                    Picker("Diet", selection: $recipe.selectedDiet) {
                        ForEach(DietType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized)
                        }
                    }
                    
                    Stepper {
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
                Image("EdamamAttributionLarge")
                    .padding(.vertical)
                
                Button(action: {
                    // TODO: viewmodel api call and navigate to Search Results
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
                
            }
            .padding(.top, 40)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
