//
//  Welcome.swift
//  
//
//  Created by toya.suzuki on 2024/03/20.
//

import ComposableArchitecture

@Reducer
public struct Welcome {
    public struct State: Equatable {
        public init() {}
    }
    
    public enum Action {
        case signInButtonTapped
        case loginButtonTapped
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .signInButtonTapped, .loginButtonTapped:
                return .none
            }
        }
    }
}
