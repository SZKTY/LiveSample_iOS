//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/01.
//

import Foundation
import Dependencies
import ComposableArchitecture

public struct SelectMode: Reducer, Sendable {
    public struct State: Equatable {
        public init() {}
    }
    
    public enum Action: Equatable {
        case didTapFan
        case didTapMusician
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .didTapFan:
                return .none
            case .didTapMusician:
                return .none
            }
        }
    }
}

