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
    @State private var isSecure = true
    @State var isFirstEntryAfterToggle = false
    
    public init(_ titleKey: String, text: Binding<String>) {
        self.titleKey = titleKey
        _text = text
    }
    
    public var body: some View {
        HStack {
            DisablePasteTextField(
                placeHolder: titleKey,
                text: $text,
                isSecureTextEntry: $isSecure
            )
            
            Button {
                isSecure.toggle()
            } label: {
                Image(systemName: isSecure ? "eye.slash" : "eye")
                    .font(.system(size: 16))
                    .accentColor(.gray.opacity(0.8))
            }
            .buttonStyle(.plain)
        }
    }
}
