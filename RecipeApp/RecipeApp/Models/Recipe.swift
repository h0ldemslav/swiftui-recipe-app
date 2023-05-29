//
//  RecipeModel.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 29.05.2023.
//

import Foundation
import SwiftUI

struct _Recipe: Identifiable {
    let id: UUID = UUID()
    let label: String?
    let healthLabels: [String]?
    let ingredients: [_Ingredient]?
    let instructions: [String]?
    let image: String?
    let source, url, shareAs: String?
    let dietLabels, cautions, ingredientLines: [String]?
    let calories, glycemicIndex, totalCO2Emissions: Double?
    let co2EmissionsClass: String?
    let totalWeight: Double?
}

struct _Ingredient {
    let text: String?
    let quantity: Double?
    let measure, food: String?
    let weight: Double?
    let foodID: String?
}
