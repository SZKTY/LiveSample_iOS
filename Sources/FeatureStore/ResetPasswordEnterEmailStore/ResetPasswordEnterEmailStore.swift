//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/11/24.
//

import Foundation
import ComposableArchitecture
import ResetPasswordEnterAuthenticationCodeStore
import API
import UserDefaults
import Validator

@Reducer
public struct ResetPasswordEnterEmail: Sendable {
    public struct State: Equatable {
        @PresentationState public var destination: Path.State?
        @PresentationState public var alert: AlertState<Action.Alert>?
        
        @BindingState public var email: String = ""
        @BindingState public var isEnableNextButton: Bool = false
        @BindingState public var isBusy: Bool = false
        
        public init() {}
    }
    
    public enum Action: BindableAction {
        case nextButtonTapped
        case resetPasswordStartVerificationResponse(Result<ResetPasswordStartVerificationResponse, Error>)
        case destination(PresentationAction<Path.Action>)
        case alert(PresentationAction<Alert>)
        case binding(BindingAction<State>)
        case didChangeEmail
        
        public enum Alert: Equatable {
            case failToSendAuthenticationCode
        }
    }
    
    public init() {}
    
    // MARK: - Dependencies
    @Dependency(\.resetPasswordStartVerificationClient) var resetPasswordStartVerificationClient
    @Dependency(\.userDefaults) var userDefaults
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .nextButtonTapped:
                guard !state.isBusy else { return .none }
                state.isBusy = true
                
                return .run { [email = state.email] send in
                    await send(.resetPasswordStartVerificationResponse(Result {
                        try await resetPasswordStartVerificationClient.send(email: email)
                    }))
                }
                
            case let .resetPasswordStartVerificationResponse(.success(response)):
                print("check: Send AuthenticationCode SUCCESS")
                state.isBusy = false
                
                state.destination = .resetPasswordEnterAuthenticationCode(
                    ResetPasswordEnterAuthenticationCode.State(email: state.email)
                )
                
                return .none

            case let .resetPasswordStartVerificationResponse(.failure(error)):
                print("check: Send AuthenticationCode FAIL")
                state.alert = AlertState(title: TextState(error.asApiError?.message ?? error.localizedDescription))
                state.isBusy = false
                
                return .none
                
            case .destination:
                return .none
                
            case .alert:
                return .none
                
            case .binding:
                return .none
                
            case .didChangeEmail:
                state.isEnableNextButton = Validator.isEmail(state.email)
                print("変更:", state.email, "Validator.isEmail(state.email):", Validator.isEmail(state.email))
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        .ifLet(\.$alert, action: \.alert)
        
        BindingReducer()
    }
}

extension ResetPasswordEnterEmail {
    @Reducer(state: .equatable)
    public enum Path {
        case resetPasswordEnterAuthenticationCode(ResetPasswordEnterAuthenticationCode)
    }
}
