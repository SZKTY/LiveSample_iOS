//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/06/19.
//

import SwiftUI

public struct RemovableCircleImageButton: View {
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
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(Circle())
                    .frame(
                        width: UIScreen.main.bounds.width*0.5,
                        height: UIScreen.main.bounds.width*0.5
                    )
            }
            
            ZStack {
                Circle()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.white)
                
                Button(action: {
                    self.removeAction()
                }) {
                    Image(systemName: "minus.circle.fill")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .cornerRadius(14)
                        .foregroundColor(.black)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .offset(x: -12, y: 12)
        }
    }
}

