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
    
    @ObservedObject var viewModel: RecipesViewModel
    
    let rows = [GridItem(.fixed(30)), GridItem(.fixed(30))]
    
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
                        viewModel.addNewRecipe(
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

struct NewRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        NewRecipeView(isPresented: .constant(true), viewModel: RecipesViewModel())
    }
}
