//
//  File.swift
//
//
//  Created by toya.suzuki on 2024/06/19.
//

import SwiftUI

public struct PasswordTextField: View {
    private let titleKey: String
    @Binding private var text: String
    @State private var isShowSecure = false
    @FocusState private var isTextFieldFocused: Bool
    @FocusState private var isSecureFieldFocused: Bool
    @State var isFirstEntryAfterToggle = false
    
    public init(_ titleKey: String, text: Binding<String>) {
        self.titleKey = titleKey
        _text = text
    }
    
    public var body: some View {
        HStack {
            ZStack {
                DisablePasteTextField(placeHolder: titleKey, text: $text)
                    .focused($isTextFieldFocused)
                    .keyboardType(.asciiCapable)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.none)
                    .opacity(isShowSecure ? 1 : 0)
                
                SecureField(titleKey, text: $text)
                    .focused($isSecureFieldFocused)
                    .opacity(isShowSecure ? 0 : 1)
            }
            
            Button {
                if isShowSecure {
                    isShowSecure = false
                    isSecureFieldFocused = true
                    
                    if !text.isEmpty {
                        isFirstEntryAfterToggle = true
                    }
                } else {
                    isShowSecure = true
                    isTextFieldFocused = true
                    isFirstEntryAfterToggle = false
                }
            } label: {
                Image(systemName: isShowSecure ? "eye" : "eye.slash")
                    .font(.system(size: 16))
                    .accentColor(.gray.opacity(0.8))
            }
            .buttonStyle(.plain)
        }
        .onChange(of: text) { [text] newValue in
            if newValue.count == 1 && isFirstEntryAfterToggle {
                self.text = text + newValue
            }
            isFirstEntryAfterToggle = false
        }
    }
}
