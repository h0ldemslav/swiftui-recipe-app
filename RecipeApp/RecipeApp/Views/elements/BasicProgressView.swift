//
//  BasicProgressView.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 23.06.2023.
//

import SwiftUI

struct BasicProgressView: View {
    var label: String
    var textColor: Color
    var circleTintColor: Color
    var borderColor: Color
    var borderWidth: CGFloat
    var backgroundColor: Color
    
    var body: some View {
        ProgressView {
            Text(label)
                .foregroundColor(.black)
        }
        .progressViewStyle(CircularProgressViewStyle(tint: circleTintColor))
        .padding(.all)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(borderColor, lineWidth: borderWidth)
        )
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(backgroundColor)
        )
    }
}

struct BasicProgressView_Previews: PreviewProvider {
    static var previews: some View {
        BasicProgressView(
            label: "Progress label",
            textColor: .black,
            circleTintColor: .black,
            borderColor: .black,
            borderWidth: 1,
            backgroundColor: .white
        )
    }
}
