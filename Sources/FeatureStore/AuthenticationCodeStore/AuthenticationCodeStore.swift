//
//  AuthenticationCode.swift
//  
//
//  Created by toya.suzuki on 2024/03/24.
//

import Foundation
import ComposableArchitecture
import PasswordStore
import API
import UserDefaults
import Validator

@Reducer
public struct AuthenticationCode: Sendable {
    public struct State: Equatable {
        @PresentationState public var destination: Path.State?
        @PresentationState public var alert: AlertState<Action.Alert>?
        
        @BindingState public var code: String = ""
        @BindingState public var isEnableNextButton: Bool = false
        @BindingState public var isBusy: Bool = false
        
        public var email: String
        
        public init(email: String) {
            self.email = email
        }
    }
    
    public enum Action: BindableAction {
        case nextButtonTapped
        case verifyAuthenticationCodeResponse(Result<VerifyAuthenticationCodeResponse, Error>)
        
        case destination(PresentationAction<Path.Action>)
        case alert(PresentationAction<Alert>)
        case binding(BindingAction<State>)
        case didChangeAuthenticationCode
        
        public enum Alert: Equatable {
        }
    }
    
    public init() {}
    
    // MARK: - Dependencies
    @Dependency(\.verifyauthenticationCodeClient) var verifyauthenticationCodeClient
    @Dependency(\.userDefaults) var userDefaults
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .nextButtonTapped:
                guard !state.isBusy else { return .none }
                state.isBusy = true
                
                return .run { [
                    email = state.email,
                    code = state.code
                ] send in
                    await send(.verifyAuthenticationCodeResponse(Result {
                        try await verifyauthenticationCodeClient.send(email: email, code: code)
                    }))
                }
                
            case let .verifyAuthenticationCodeResponse(.success(response)):
                print("check: verifyAuthenticationCodeResponse SUCCESS")
                state.isBusy = false
                state.destination = .password(Password.State(email: state.email))
                return .none
                
            case let .verifyAuthenticationCodeResponse(.failure(error)):
                print("check: verifyAuthenticationCodeResponse FAIL")
                state.alert = AlertState(title: TextState(error.asApiError?.message ?? error.localizedDescription))
                state.isBusy = false
                return .none
                
            case .destination:
                return .none
                
            case .alert:
                return .none
                
            case .binding:
                return .none
                
            case .didChangeAuthenticationCode:
                state.isEnableNextButton = state.code.count == 6
                print("変更:", state.code)
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        .ifLet(\.$alert, action: \.alert)
        
        BindingReducer()
    }
}

extension AuthenticationCode {
    @Reducer(state: .equatable)
    public enum Path {
        case password(Password)
    }
}
