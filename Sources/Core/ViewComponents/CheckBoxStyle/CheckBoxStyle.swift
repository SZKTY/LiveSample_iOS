//
//  File.swift
//
//
//  Created by toya.suzuki on 2024/06/19.
//

import SwiftUI

public struct CheckBoxStyle: ToggleStyle {
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            Button {
                configuration.isOn.toggle()
            } label: {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
            }
            .foregroundStyle(configuration.isOn ? Color.accentColor : Color.primary)
            
            configuration.label
        }
    }
}

extension ToggleStyle where Self == CheckBoxStyle {
    public static var checkBox: CheckBoxStyle {
        .init()
    }
}
