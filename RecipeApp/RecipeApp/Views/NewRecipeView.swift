//
//  NewRecipeView.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 31.05.2023.
//

import SwiftUI

struct NewRecipeView: View {
    
    @State var name: String = ""
    @Binding var isPresented: Bool
    
    @StateObject var coreDataViewModel: CoreDataViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Dad's lasagna", text: $name)
                } header: {
                    Text("Name")
                        .font(.headline)
                } footer: {
                    
                }
            }
            
            .navigationTitle("New recipe")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Save") {
                        coreDataViewModel.addNewRecipe(
                            name: name,
                            ingredients: "",
                            instructions: "",
                            image: nil
                        )
                        
                        isPresented = false
                    }
                }
            }
        }
    }
}
