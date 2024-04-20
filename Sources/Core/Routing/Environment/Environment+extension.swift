//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/18.
//

import SwiftUI

// MARK: - DI

struct ViewBuildingKey: EnvironmentKey {
    // デバッグ時 MainAppのViewBuilding を差し込む
    public static var defaultValue: any ViewBuildingProtocol = ModuleViewBuilding()
}

extension EnvironmentValues {
    public var viewBuilding: any ViewBuildingProtocol {
        get { self[ViewBuildingKey.self] }
        set { self[ViewBuildingKey.self] = newValue }
    }
}
