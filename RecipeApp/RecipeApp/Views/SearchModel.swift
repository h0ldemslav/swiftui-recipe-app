//
//  SearchModel.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 05.05.2023.
//

import Foundation

enum MealType: String, CaseIterable {
    case Breakfast
    case Dinner
    case Lunch
    case Snack
    case Teatime
}

enum DietType: String, CaseIterable {
    case Balanced = "balanced"
    case HighFiber = "high-fiber"
    case HighProtein = "high-protein"
    case LowCarb = "low-carb"
    case LowFat = "low-fat"
    case LowSodium = "low-sodium"
}

struct SearchRecipe {
    var name: String = ""
    var selectedDiet: DietType = .HighProtein
    var selectedTypeOfMeal: MealType = .Lunch
    var calories: Int32 = 100
        
    mutating func incrementCalories() {
        calories += 100
    }

    mutating func decrementCalories() {
        calories -= 100
        if calories <= 0 { calories = 100 }
    }
}
