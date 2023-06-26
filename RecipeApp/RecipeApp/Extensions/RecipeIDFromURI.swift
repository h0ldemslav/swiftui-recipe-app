//
//  RecipeIDFromURI.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 26.06.2023.
//

import Foundation

extension String {
    
    func getIDFromRecipeURI() -> String? {
        if let indexOfHash = self.firstIndex(of: "#") {
            let recipeIDStart = self.index(after: indexOfHash)
            let remoteID = String(self[recipeIDStart...])
            
            return remoteID
        }
        
        return nil
    }
}
