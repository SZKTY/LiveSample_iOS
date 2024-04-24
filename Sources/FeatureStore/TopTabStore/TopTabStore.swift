//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/08.
//

import ComposableArchitecture

@Reducer
public struct TopTab {
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
        BindingReducer()
    }
}
