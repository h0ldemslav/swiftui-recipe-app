//
//  ContentView.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 03.05.2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var recipeViewModel: RecipesViewModel = RecipesViewModel()
    
    var body: some View {
        TabView {
            APIRecipesView()
                .tabItem {
                    SwiftUI.Label("Edamam recipes", systemImage: "e.circle")
                }
            
            SearchView()
                .tabItem {
                    SwiftUI.Label("Search", systemImage: "magnifyingglass")
                }
            
            MyRecipesView(viewModel: recipeViewModel)
                .tabItem {
                    SwiftUI.Label("My recipes", systemImage: "text.book.closed")
                }
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
