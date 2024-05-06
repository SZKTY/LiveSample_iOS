//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/05/06.
//

import SwiftUI

public struct NoImageButton: View {
    public let action: () -> Void
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            self.action()
        }) {
            Image(systemName: "camera")
                .padding()
                .font(.system(size: 20))
                .frame(width: 80, height: 80)
                .overlay(RoundedRectangle(cornerRadius: 2)
                    .stroke(style: StrokeStyle(dash: [8,7])))
                .foregroundColor(Color.gray)
                .background(Color.white)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
