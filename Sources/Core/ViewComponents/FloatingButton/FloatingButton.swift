//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/05/04.
//

import SwiftUI

public struct FloatingButton: View {
    private let action: () -> ()
    private let imageName: String
    private let position: FloatingButtonPosition
    
    public init(position: FloatingButtonPosition, imageName: String, action: @escaping () -> Void) {
        self.position = position
        self.imageName = imageName
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
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                        .bold()
                })
                .frame(width: 60, height: 60)
                .background(.black)
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
            return EdgeInsets(top: 0, leading: 16.0, bottom: 16.0, trailing: 0)
        case .bottomTailing:
            return EdgeInsets(top: 0, leading: 0, bottom: 16.0, trailing: 16.0)
        }
        
    }
    
}

public enum FloatingButtonPosition {
    case topLeading
    case topTailing
    case bottomLeading
    case bottomTailing
}
