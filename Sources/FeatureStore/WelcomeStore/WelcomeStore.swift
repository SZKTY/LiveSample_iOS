//
//  Welcome.swift
//  
//
//  Created by toya.suzuki on 2024/03/20.
//

import ComposableArchitecture
import MailAddressPasswordStore

@Reducer
public struct Welcome {
    public struct State: Equatable {
        @PresentationState public var destination: Path.State?
        
        public init() {}
    }
    
    public enum Action: BindableAction {
        case signInButtonTapped
        case loginButtonTapped
        case destination(PresentationAction<Path.Action>)
        case binding(BindingAction<State>)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .signInButtonTapped:
                state.destination = .mailAddressPassword(MailAddressPassword.State(isLogin: false))
                return .none
            case .loginButtonTapped:
                state.destination = .mailAddressPassword(MailAddressPassword.State(isLogin: true))
                return .none
            case .binding:
                return .none
            case .destination(_):
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        
        BindingReducer()
    }
}

extension Welcome {
    @Reducer(state: .equatable)
    public enum Path {
        case mailAddressPassword(MailAddressPassword)
    }
}
