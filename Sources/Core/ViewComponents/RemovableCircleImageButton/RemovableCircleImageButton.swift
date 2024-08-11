//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/06/19.
//

import SwiftUI

public struct RemovableCircleImageButton: View {
    @Binding public var image: Data
    
    public let tapAction: () -> Void
    public let removeAction: () -> Void
    public let ration: Double
    public let isShownDeleteButton: Bool
    
    public init(
        tapAction: @escaping () -> Void,
        removeAction: @escaping () -> Void,
        image: Binding<Data>,
        ration: Double = 1,
        isShownDeleteButton: Bool = true
    ) {
        self.tapAction = tapAction
        self.removeAction = removeAction
        self._image = image
        self.ration = ration
        self.isShownDeleteButton = isShownDeleteButton
    }
    
    public var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: {
                self.tapAction()
            }) {
                Image(uiImage: UIImage(data: image) ?? UIImage(named: "noImage")!)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: UIScreen.main.bounds.width * 0.5 * ration,
                        height: UIScreen.main.bounds.width * 0.5 * ration
                    )
                    .clipShape(Circle())
            }
            
            if isShownDeleteButton {
                ZStack {
                    Circle()
                        .frame(width: 32 * ration, height: 32 * ration)
                        .foregroundColor(.white)
                    
                    Button(action: {
                        self.removeAction()
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .frame(width: 28 * ration, height: 28 * ration)
                            .cornerRadius(14)
                            .foregroundColor(.black)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .offset(x: -12 * ration, y: 12 * ration)
            }
        }
    }
}

