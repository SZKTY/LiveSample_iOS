//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/06/19.
//

import SwiftUI

public struct TextFieldModifier: ViewModifier {
    public init() {}
    
    public func body(content: Content) -> some View {
        content
            .font(.system(size: 25, weight: .medium))
            .padding()
            .foregroundColor(Color.mainBaseColor)
            .background(.white)
            .cornerRadius(8)
            .overlay(
                   RoundedRectangle(cornerRadius: 8)
                   .stroke(Color.mainBaseColor, lineWidth: 1.0)
           )
    }
}
