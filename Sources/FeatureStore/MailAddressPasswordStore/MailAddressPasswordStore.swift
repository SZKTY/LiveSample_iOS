//
//  MailAddressPassword.swift
//  
//
//  Created by toya.suzuki on 2024/03/24.
//

import Foundation
import ComposableArchitecture
import AccountIdStore

@Reducer
public struct MailAddressPassword: Sendable {
    public struct State: Equatable {
        @PresentationState public var destination: Path.State?
        @BindingState public var email: String = ""
        @BindingState public var password: String = ""
        
        public init() {}
    }
    
    public enum Action: BindableAction {
        case nextButtonTapped
        case destination(PresentationAction<Path.Action>)
        case binding(BindingAction<State>)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .nextButtonTapped:
                state.destination = .accountId(AccountId.State())
                return .none
            case .destination:
                return .none
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
        .ifLet(\.$destination, action: \.destination)
        
        BindingReducer()
    }
}

extension MailAddressPassword {
    @Reducer(state: .equatable)
    public enum Path {
        case accountId(AccountId)
    }
}
