//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/08/04.
//

import Foundation
import SwiftUI
import UIKit

public struct DisablePasteTextField: UIViewRepresentable {
    public typealias UIViewType = ProtectedTextField
    public let placeHolder: String
    
    @Binding var text: String
    
    public init(placeHolder: String, text: Binding<String>) {
        self.placeHolder = placeHolder
        _text = text
    }
    
    public func makeUIView(context: Context) -> ProtectedTextField {
        let textField = ProtectedTextField()
        textField.placeholder = placeHolder
        textField.delegate = context.coordinator
        textField.font = .systemFont(ofSize: 25, weight: .medium)
        textField.keyboardType = .asciiCapable
        return textField
    }
    
    // From SwiftUI to UIKit
    public func updateUIView(_ uiView: ProtectedTextField, context: Context) {
        uiView.text = text
    }
    
    // From UIKit to SwiftUI
    public func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    public class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        
        public init(text: Binding<String>) {
            self._text = text
        }
        
        public func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
}

// Custom TextField with disabling paste action
public class ProtectedTextField: UITextField {
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
