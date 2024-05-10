//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/05/06.
//

import SwiftUI

public struct RemovableImageButton: View {
    public let tapAction: () -> Void
    public let removeAction: () -> Void
    public let image: Data
    
    public init(tapAction: @escaping () -> Void, removeAction: @escaping () -> Void, image: Data) {
        self.tapAction = tapAction
        self.removeAction = removeAction
        self.image = image
    }
    
    public var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: {
                self.tapAction()
            }) {
                Image(uiImage: UIImage(data: image) ?? UIImage(named: "noImage")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .frame(width: 80, height: 80)
            
            ZStack {
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                
                Button(action: {
                    self.removeAction()
                }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .offset(x: 5, y: -5)
        }
    }
}

