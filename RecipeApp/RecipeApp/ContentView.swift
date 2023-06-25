//
//  ContentView.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 03.05.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 1
    @StateObject var recipesViewModel: RecipesViewModel = RecipesViewModel()
    
    var body: some View {
        TabView(selection: $selection) {
            APIRecipesView(viewModel: recipesViewModel)
                .tabItem {
                    SwiftUI.Label("Web recipes", systemImage: "w.circle")
                }
                    .tag(2)
            
            SearchView(recipesViewModel: recipesViewModel)
                .tabItem {
                    SwiftUI.Label("Search", systemImage: "magnifyingglass")
                }
                    .tag(1)
            
            MyRecipesView(viewModel: recipesViewModel)
                .tabItem {
                    SwiftUI.Label("My recipes", systemImage: "text.book.closed")
                }
                    .tag(3)
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
