//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/05/04.
//

import SwiftUI
import Assets

public struct FloatingView<Content: View>: View {
    private let position: FloatingPosition
    private let content: Content
    
    public init(
        position: FloatingPosition,
        @ViewBuilder content: () -> Content
    ) {
        self.position = position
        self.content = content()
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
                
                content
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

public enum FloatingPosition {
    case topLeading
    case topTailing
    case bottomLeading
    case bottomTailing
}
