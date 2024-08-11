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
    public let validJapanese: Bool
    
    @Binding var text: String
    @Binding var isSecureTextEntry: Bool
    
    public init(
        placeHolder: String,
        text: Binding<String>,
        isSecureTextEntry: Binding<Bool> = .constant(false),
        validJapanese: Bool = true
    ) {
        self.placeHolder = placeHolder
        _text = text
        _isSecureTextEntry = isSecureTextEntry
        self.validJapanese = validJapanese
    }
    
    public func makeUIView(context: Context) -> ProtectedTextField {
        let textField = ProtectedTextField(frame: .zero)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.placeholder = placeHolder
        textField.font = .systemFont(ofSize: 25, weight: .medium)
        textField.keyboardType = .asciiCapable
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.delegate = context.coordinator
        
        return textField
    }
    
    // From SwiftUI to UIKit
    public func updateUIView(_ uiView: ProtectedTextField, context: Context) {
        uiView.text = text
        uiView.isSecureTextEntry = isSecureTextEntry
    }
    
    // From UIKit to SwiftUI
    public func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, validJapanese: validJapanese)
    }
    
    public class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        let validJapanese: Bool
        
        public init(text: Binding<String>, validJapanese: Bool) {
            self._text = text
            self.validJapanese = validJapanese
        }
        
        public func textField(
            _ textField: UITextField,
            shouldChangeCharactersIn range: NSRange,
            replacementString string: String
        ) -> Bool {
            guard validJapanese else { return true }
            
            let fullWidthRegex = "[\\p{Han}\\p{Hiragana}\\p{Katakana}、。！？￥ａ-ｚＡ-Ｚ０-９]"
            
            if string.range(of: fullWidthRegex, options: .regularExpression) != nil {
                // 日本語または全角文字が含まれている場合は、入力を拒否
                return false
            }
            return true
        }
        
        public func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
}

// Custom TextField with disabling paste action
public class ProtectedTextField: UITextField {
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}


public struct DisablePasteTextView: UIViewRepresentable {
    public typealias UIViewType = ProtectedTextView
    public let placeHolder: String
    
    @Binding var text: String
    
    public init(
        placeHolder: String,
        text: Binding<String>
    ) {
        self.placeHolder = placeHolder
        _text = text
    }
    
    public func makeUIView(context: Context) -> ProtectedTextView {
        let textView = ProtectedTextView(frame: .zero)
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        textView.placeholder = placeHolder
        textView.font = .systemFont(ofSize: 16, weight: .medium)
        textView.delegate = context.coordinator
        
        return textView
    }
    
    // From SwiftUI to UIKit
    public func updateUIView(_ uiView: ProtectedTextView, context: Context) {
        uiView.text = text
    }
    
    // From UIKit to SwiftUI
    public func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    public class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        
        public init(text: Binding<String>) {
            self._text = text
        }
        
        public func textViewDidChangeSelection(_ textView: UITextView) {
            text = textView.text.replacingOccurrences(of: "\n", with: "")
        }
    }
}

// Custom TextView with disabling paste action
public class ProtectedTextView: UITextView {
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
