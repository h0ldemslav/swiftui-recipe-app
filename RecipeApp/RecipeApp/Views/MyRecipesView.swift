//
//  MyRecipesView.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 26.05.2023.
//

import SwiftUI
import CoreData

struct MyRecipesView: View {
    @State var recipeSearchValue = ""
    @State var isNewRecipePresented = false
    @State var isDetailRecipePresented = false
    
    private var viewContext: NSManagedObjectContext
    
    @ObservedObject var coreDataViewModel: CoreDataViewModel = CoreDataViewModel(context: viewContext)
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Search", text: $recipeSearchValue)
                        .padding(.leading, 32)
                        .cornerRadius(10)
                        .overlay(
                            Image(systemName: "magnifyingglass"),
                            alignment: .leading
                        )
                }
                    
                Section {
                    List {
                        ForEach(coreDataViewModel.recipes, id: \.self) { recipe in
                            
                            if let label = recipe.name {
                                Text(label)
                                    .onTapGesture {
                                        isDetailRecipePresented = true
                                    }
                            }
                            
                        }
                        .onDelete(perform: coreDataViewModel.deleteRecipe)
                    }
                }
                
            }
            .navigationTitle("My recipes")
            
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("New recipe") {
                        isNewRecipePresented = true
                    }
                }
            }
            
            .sheet(isPresented: $isDetailRecipePresented) {
                RecipeDetailView()
            }
        }
        .sheet(isPresented: $isNewRecipePresented) {
            NewRecipeView(
                isPresented: $isNewRecipePresented,
                coreDataViewModel: coreDataViewModel
            )
        }
    }
}

struct MyRecipesView_Previews: PreviewProvider {
    static var previews: some View {
        MyRecipesView()
    }
}
