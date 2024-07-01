//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/08.
//

import UIKit
import SwiftUI

public struct ImagePicker: UIViewControllerRepresentable {
    public var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Environment(\.presentationMode) private var presentationMode
    @Binding public var selectedImage: Data
    
    public var completion: (() -> ())? = nil
    
    public init(
        sourceType: UIImagePickerController.SourceType = .photoLibrary,
        selectedImage: Binding<Data>,
        completion: (() -> ())? = nil
    ) {
        self.sourceType = sourceType
        _selectedImage = selectedImage
        self.completion = completion
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    public final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        public var parent: ImagePicker
        
        public init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[.originalImage] as? UIImage,
               let jpeg = image.jpegData(compressionQuality: 1.0),
               self.parent.selectedImage != jpeg {
                self.parent.selectedImage = jpeg
                self.parent.completion?()
            }
            
            self.parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

