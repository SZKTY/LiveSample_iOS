//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/05/03.
//

import Foundation

public struct Config: Equatable {
    public var requiredVersion: NSNumber?
    
    public init() {}
}

// MARK: - extension

extension Config {
    public static func stub() -> Self {
        var conifg = Self()
        conifg.requiredVersion = 0
        
        return conifg
    }
}
