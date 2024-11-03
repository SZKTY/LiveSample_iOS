//
//  MailAddress.swift
//
//
//  Created by toya.suzuki on 2024/03/24.
//

import Foundation
import ComposableArchitecture
import AuthenticationCodeStore
import API
import UserDefaults
import Validator

@Reducer
public struct MailAddress: Sendable {
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
        case verifyMailAdressResponse(Result<VerifyMailAdressResponse, Error>)
        
        case destination(PresentationAction<Path.Action>)
        case alert(PresentationAction<Alert>)
        case binding(BindingAction<State>)
        case didChangeEmail
        
        public enum Alert: Equatable {
        }
    }
    
    public init() {}
    
    // MARK: - Dependencies
    @Dependency(\.verifyMailAdressClient) var verifyMailAdressClient
    @Dependency(\.userDefaults) var userDefaults
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .nextButtonTapped:
                guard !state.isBusy else { return .none }
                state.isBusy = true
                
                return .run { [email = state.email] send in
                    await send(.verifyMailAdressResponse(Result {
                        try await verifyMailAdressClient.send(email: email)
                    }))
                }
                
            case let .verifyMailAdressResponse(.success(response)):
                print("check: verifyMailAdressResponse SUCCESS")
                state.isBusy = false
                state.destination = .authenticationCode(AuthenticationCode.State(email: state.email))
                return .none
                
            case let .verifyMailAdressResponse(.failure(error)):
                print("check: verifyMailAdressResponse FAIL")
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

extension MailAddress {
    @Reducer(state: .equatable)
    public enum Path {
        case authenticationCode(AuthenticationCode)
    }
}
