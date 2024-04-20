//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/18.
//

import SwiftUI

// Module へ MainAppの画面遷移実装 を差し込むために定義
public protocol ViewBuildingProtocol {
    func build(viewType: ViewType) -> AnyView
}
