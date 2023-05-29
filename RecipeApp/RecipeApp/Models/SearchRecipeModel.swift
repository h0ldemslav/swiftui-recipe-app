//
//  SearchModel.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 05.05.2023.
//

import Foundation

enum SearchRecipeConstants {
    static let caloriesStart: Int = 100
    static let caloriesEnd: Int = 300
    static let caloriesMaximum: Int = 5000
    static let caloriesIncrementDecrement: Int = 200
}

enum _MealType: String, CaseIterable {
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
    var selectedTypeOfMeal: _MealType = .Lunch
    var caloriesStart: Int = SearchRecipeConstants.caloriesStart
    var caloriesEnd: Int = SearchRecipeConstants.caloriesEnd
        
    mutating func incrementCalories() {
        let nextCaloriesEndOffset = caloriesEnd + SearchRecipeConstants.caloriesIncrementDecrement
        
        if (nextCaloriesEndOffset < SearchRecipeConstants.caloriesMaximum) {
            caloriesStart += SearchRecipeConstants.caloriesIncrementDecrement
            caloriesEnd += SearchRecipeConstants.caloriesIncrementDecrement
        }
    }

    mutating func decrementCalories() {
        caloriesStart -= SearchRecipeConstants.caloriesIncrementDecrement
        caloriesEnd -= SearchRecipeConstants.caloriesIncrementDecrement
        
        if caloriesStart <= 0 {
            caloriesStart = SearchRecipeConstants.caloriesStart
        }
        
        if caloriesEnd < SearchRecipeConstants.caloriesEnd {
            caloriesEnd = SearchRecipeConstants.caloriesEnd
        }
    }
}
