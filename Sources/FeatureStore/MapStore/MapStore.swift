//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/24.
//

import ComposableArchitecture

@Reducer
public struct MapStore {
    public struct State: Equatable {
        public init() {}
    }
    
    public enum Action: BindableAction {
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
    }
}
