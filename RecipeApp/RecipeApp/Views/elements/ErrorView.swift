//
//  ErrorView.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 29.05.2023.
//

import SwiftUI

struct ErrorView: View {
    var body: some View {
        Text("Name cannot be empty")
            .foregroundColor(.red)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
    }
}
