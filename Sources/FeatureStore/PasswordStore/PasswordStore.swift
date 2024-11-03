//
//  Password.swift
//  
//
//  Created by toya.suzuki on 2024/03/24.
//

import Foundation
import ComposableArchitecture
import AccountIdNameStore
import API
import UserDefaults
import Validator

@Reducer
public struct Password: Sendable {
    public struct State: Equatable {
        @PresentationState public var destination: Path.State?
        @PresentationState public var alert: AlertState<Action.Alert>?
        
        @BindingState public var password: String = ""
        @BindingState public var isEnableNextButton: Bool = false
        @BindingState public var isBusy: Bool = false
        
        public var email: String
        
        public init(email: String) {
            self.email = email
        }
    }
    
    public enum Action: BindableAction {
        case nextButtonTapped
        case issueAccountResponse(Result<IssueAccountResponse, Error>)
        case destination(PresentationAction<Path.Action>)
        case alert(PresentationAction<Alert>)
        case binding(BindingAction<State>)
        case didChangePassword
        
        public enum Alert: Equatable {
        }
    }
    
    public init() {}
    
    // MARK: - Dependencies
    @Dependency(\.issueAccountClient) var issueAccountClient
    @Dependency(\.userDefaults) var userDefaults
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .nextButtonTapped:
                guard !state.isBusy else { return .none }
                state.isBusy = true
                
                return .run { [
                    email = state.email,
                    password = state.password] send in
                        await send(.issueAccountResponse(Result {
                            try await issueAccountClient.send(email: email, password: password)
                        }))
                }
                
            case let .issueAccountResponse(.success(response)):
                print("check: issueAccount SUCCESS")
                state.destination = .accountIdName(AccountIdName.State())
                state.isBusy = false
                
                return .run { send in
                    await self.userDefaults.setSessionId(response.sessionId)
                }
                
            case let .issueAccountResponse(.failure(error)):
                print("check: issueAccount FAIL")
                state.alert = AlertState(title: TextState(error.asApiError?.message ?? error.localizedDescription))
                state.isBusy = false
                return .none
                
            case .destination:
                return .none
                
            case .alert:
                return .none
                
            case .binding:
                return .none
                
            case .didChangePassword:
                state.isEnableNextButton = Validator.isPassword(state.password)
                print("変更:", state.password, "Validator.isPassword(state.password):", Validator.isPassword(state.password))
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        .ifLet(\.$alert, action: \.alert)
        
        BindingReducer()
    }
}

extension Password {
    @Reducer(state: .equatable)
    public enum Path {
        case accountIdName(AccountIdName)
    }
}
