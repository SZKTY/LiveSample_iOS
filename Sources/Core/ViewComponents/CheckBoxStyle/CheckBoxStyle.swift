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
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                configuration.label
            }
        }
        .foregroundStyle(configuration.isOn ? Color.accentColor : Color.primary)
    }
}

extension ToggleStyle where Self == CheckBoxStyle {
    public static var checkBox: CheckBoxStyle {
        .init()
    }
}
