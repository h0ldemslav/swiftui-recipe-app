//
//  BasicErrorView.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 24.06.2023.
//

import SwiftUI

struct BasicErrorView: View {
    @Binding var text: String
    @Binding var imageAssetName: String
    
    var body: some View {
        VStack {
            if let uiimage = UIImage(named: imageAssetName) {
                Image(uiImage: uiimage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
            }
            
            Text(text)
                .padding(.top, 4)
                .transition(
                    AnyTransition.opacity.animation(.easeInOut(duration: 0.5))
                )
        }
    }
}

struct BasicErrorViewSheet: View {
    @Binding var isPresented: Bool
    @Binding var text: String
    @Binding var imageAssetName: String
    
    var body: some View {
        NavigationView {
            BasicErrorView(text: $text, imageAssetName: $imageAssetName)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isPresented = false
                    } label: {
                        Label("Back", systemImage: "chevron.backward")
                            .labelStyle(.titleAndIcon)
                            .animation(.easeOut, value: isPresented)
                    }
                }
            }
        }
    }
}

struct BasicErrorView_Previews: PreviewProvider {
    static var previews: some View {
        BasicErrorViewSheet(
            isPresented: .constant(true),
            text: .constant("Error label"),
            imageAssetName: .constant("undraw_fixing_bugs")
        )
    }
}
