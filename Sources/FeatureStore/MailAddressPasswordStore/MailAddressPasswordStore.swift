//
//  MailAddressPassword.swift
//  
//
//  Created by toya.suzuki on 2024/03/24.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct MailAddressPassword: Sendable {
    
    public struct State: Equatable {
        @BindingState public var email: String = ""
        @BindingState public var password: String = ""
        
        public init() {}
    }
    
    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .binding(\.$email):
                print("変更:", state.email)
                return .none
            case .binding(\.$password):
                print("変更:", state.password)
                return .none
            case .binding:
                return .none
            }
        }
        
        BindingReducer()
    }
}

