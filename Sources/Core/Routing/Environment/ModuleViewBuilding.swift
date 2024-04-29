//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/18.
//

import SwiftUI

// DIするために 空実装
// 将来 MainAppのViewBuilding を差し込む
public struct ModuleViewBuilding: ViewBuildingProtocol {
    public func build(viewType: ViewType) -> AnyView {
        return AnyView(EmptyView())
    }
}
