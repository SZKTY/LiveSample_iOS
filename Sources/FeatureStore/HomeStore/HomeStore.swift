//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/08.
//

import Foundation
import Dependencies
import ComposableArchitecture

public struct Home: Reducer, Sendable {
    public struct State: Equatable {
        public init() {}
    }
    
    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            }
        }
        BindingReducer()
    }
}
