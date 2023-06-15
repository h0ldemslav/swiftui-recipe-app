//
//  RecipeData.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 29.05.2023.
//

import Foundation
import SwiftUI

struct RecipeData: Identifiable {
    let id: UUID?
    var name: String
    var ingredients: [IngredientData]
    var instructions: String
    var image: UIImage?
}

struct IngredientData: Identifiable {
    let id: UUID?
    var name: String
    var quantity: String
}
