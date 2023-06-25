//
//  ImagePicker.swift
//  RecipeApp
//
//  Created by Daniil Astapenko on 15.06.2023.
//

import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    
    var sourceType: UIImagePickerController.SourceType
    
    @Binding var selectedImage: UIImage?
    @Binding var isPickerPresented: Bool
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
    

}

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imagePicker: ImagePickerView
    
    init(picker: ImagePickerView) {
        imagePicker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            imagePicker.selectedImage = selectedImage
        }
        
        imagePicker.isPickerPresented = false
    }

}
