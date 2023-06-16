//
//  RecipeData.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 29.05.2023.
//

import Foundation
import SwiftUI

struct RecipeData: Identifiable, Hashable {
    let id: UUID?
    var name: String
    var ingredients: [IngredientData]
    var instructions: String
    var image: UIImage?
    var imageURL: String?
    var uri: String?
}

struct IngredientData: Identifiable, Hashable {
    let id: UUID?
    var name: String
    var quantity: String
}
