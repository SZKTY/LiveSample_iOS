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
            .padding()
            .padding(.leading, 15)
            .font(.system(size: 27, weight: .medium))
            .foregroundColor(.black)
            .background(.white)
            .cornerRadius(8)
    }
}
