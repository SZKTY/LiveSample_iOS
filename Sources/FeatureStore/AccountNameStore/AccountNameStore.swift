//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/01.
//

import Foundation
import Dependencies
import ComposableArchitecture

public struct AccountName: Reducer, Sendable {
    public struct State: Equatable {
        @BindingState public var name: String = ""
        
        public init() {}
    }
    
    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .binding(\.$name):
                print("変更:", state.name)
                return .none
            case .binding:
                return .none
            }
        }
        
        BindingReducer()
    }
}

