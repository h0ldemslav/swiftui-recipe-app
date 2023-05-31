//
//  ContentView.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 03.05.2023.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
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
            
            MyRecipesView()
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
