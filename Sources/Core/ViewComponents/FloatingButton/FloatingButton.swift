//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/05/04.
//

import SwiftUI
import Assets

public struct FloatingButton: View {
    private let position: FloatingButtonPosition
    private let imageName: String
    private let isBaseColor: Bool
    private let action: () -> ()
    
    public init(position: FloatingButtonPosition,
                imageName: String,
                isBaseColor: Bool = true,
                action: @escaping () -> Void) {
        self.position = position
        self.imageName = imageName
        self.isBaseColor = isBaseColor
        self.action = action
    }
    
    public var body: some View {
        VStack {
            if position == .bottomLeading || position == .bottomTailing {
                Spacer()
            }
            
            HStack {
                if position == .topTailing || position == .bottomTailing {
                    Spacer()
                }
                
                Button(action: {
                    self.action()
                }, label: {
                    Image(systemName: imageName)
                        .foregroundColor(isBaseColor ? .white : Color.mainBaseColor)
                        .font(.system(size: 24))
                        .bold()
                })
                .frame(width: 60, height: 60)
                .background(isBaseColor ? Color.mainBaseColor : Color.mainSubColor)
                .cornerRadius(30.0)
                .shadow(color: .gray, radius: 3, x: 3, y: 3)
                .padding(makeEdgeInsets())
                
                if position == .topLeading || position == .bottomLeading {
                    Spacer()
                }
            }
            
            if position == .topLeading || position == .topTailing {
                Spacer()
            }
        }
    }
    
    private func makeEdgeInsets() -> EdgeInsets {
        switch position {
        case .topLeading:
            return EdgeInsets(top: 80.0, leading: 16.0, bottom: 0, trailing: 0)
        case .topTailing:
            return EdgeInsets(top: 80.0, leading: 0, bottom: 0, trailing: 16.0)
        case .bottomLeading:
            return EdgeInsets(top: 0, leading: 16.0, bottom: 80.0, trailing: 0)
        case .bottomTailing:
            return EdgeInsets(top: 0, leading: 0, bottom: 80.0, trailing: 16.0)
        }
        
    }
    
}

public enum FloatingButtonPosition {
    case topLeading
    case topTailing
    case bottomLeading
    case bottomTailing
}
