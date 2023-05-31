//
//  CoreDataViewModel.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 31.05.2023.
//

import Foundation
import CoreData
import SwiftUI

class CoreDataViewModel: ObservableObject {
    
    private var viewContext: NSManagedObjectContext
    
    @Published var recipes: [RecipeEntity] = []
    
    init(context: NSManagedObjectContext) {
        viewContext = context
    }
    
    func fetchAllRecipes() {
        let request = NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
        
        do {
            recipes = try viewContext.fetch(request)
        } catch let error {
            print("Failed fetching data: \(error)")
        }
    }
    
    func addNewRecipe(name: String, ingredients: String, instructions: String, image: UIImage?) {
        let recipeEntity = RecipeEntity(context: viewContext)
        
        recipeEntity.name = name
        recipeEntity.ingredients = ingredients
        recipeEntity.instructions = instructions
        recipeEntity.image = image?.pngData()
        
        saveData()
    }
    
    func addRecipeFromApi(name: String, uri: String) {
        let recipeEntity = RecipeEntity(context: viewContext)
        
        recipeEntity.name = name
        recipeEntity.uri = uri
        
        saveData()
    }
    
    func deleteRecipe(indexSet: IndexSet) {
        guard let index = indexSet.first else {
            return
        }
        
        let recipeEntity = recipes[index]
        viewContext.delete(recipeEntity)
        
        saveData()
    }
    
    private func saveData() {
        do {
            try viewContext.save()
            fetchAllRecipes() // reassigning published variable to update the view
        } catch let error {
            print("Failed saving data: \(error)")
        }
    }
}
