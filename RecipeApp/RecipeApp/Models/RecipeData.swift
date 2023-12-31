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
    var calories: Double?
    var healthLabels: [String]?
    var digestData: [String: Double]?
    var image: UIImage?
    var imageURL: String?
    var remoteID: String? // for api's recipes
}

struct IngredientData: Identifiable, Hashable {
    let id: UUID?
    var name: String
    var quantity: String
}
