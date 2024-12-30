//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/11/03.
//

import SwiftUI
import Assets

public struct FloatingButton: View {
    private let imageName: String
    private let isBaseColor: Bool
    private let isLarge: Bool
    private let action: () -> Void
    
    private var size: CGFloat {
        isLarge ? 60.0 : 40.0
    }
    
    private var radius: CGFloat {
        isLarge ? 30.0 : 20.0
    }
    
    private var fontSize: CGFloat {
        isLarge ? 24.0 : 16.0
    }
    
    
    public init(
        imageName: String,
        isBaseColor: Bool = true,
        isLarge: Bool = true,
        action: @escaping () -> Void
    ) {
        self.imageName = imageName
        self.isBaseColor = isBaseColor
        self.isLarge = isLarge
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            action()
        }, label: {
            Image(systemName: imageName)
                .foregroundColor(isBaseColor ? .white : Color.mainBaseColor)
                .font(.system(size: fontSize, weight: .bold))
                .frame(width: size, height: size)
                .background(isBaseColor ? Color.mainBaseColor : Color.mainSubColor)
                .cornerRadius(radius)
                .shadow(color: .gray, radius: 3, x: 3, y: 3)
        })
    }
}
