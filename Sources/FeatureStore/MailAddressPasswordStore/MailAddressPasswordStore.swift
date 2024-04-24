//
//  MailAddressPassword.swift
//  
//
//  Created by toya.suzuki on 2024/03/24.
//

import Foundation
import ComposableArchitecture
import AccountIdNameStore
import API
import Validator

@Reducer
public struct MailAddressPassword: Sendable {
    public struct State: Equatable {
        @PresentationState public var destination: Path.State?
        @PresentationState public var alert: AlertState<Action.Alert>?
        
        @BindingState public var email: String = ""
        @BindingState public var password: String = ""
        @BindingState public var isEnableNextButton: Bool = false
        
        public init() {}
    }
    
    public enum Action: BindableAction {
        case nextButtonTapped
        case issueAccountResponse(Result<IssueAccountResponse, Error>)
        case destination(PresentationAction<Path.Action>)
        case alert(PresentationAction<Alert>)
        case binding(BindingAction<State>)
        
        public enum Alert: Equatable {
            case failToIssueAccount
        }
    }
    
    public init() {}
    
    // MARK: - Dependencies
    @Dependency(\.issueAccountClient) var issueAccountClient
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .nextButtonTapped:
                return .run { [email = state.email, password = state.password] send in
                    await send(.issueAccountResponse(Result {
                        try await issueAccountClient.send(email: email, password: password)
                    }))
                }
            case let .issueAccountResponse(.success(response)):
                state.destination = .accountIdName(AccountIdName.State())
                return .none
            case let .issueAccountResponse(.failure(error)):
                // エラーハンドリング
                state.alert = AlertState(title: TextState("登録失敗"))
                return .none
            case .destination:
                return .none
            case .alert(.presented(.failToIssueAccount)):
                return .none
            case .alert:
                return .none
            case .binding(\.$email):
                state.isEnableNextButton = Validator.isEmail(state.email) && Validator.isPassword(state.password)
                print("変更:", state.email, "Validator.isEmail(state.email):", Validator.isEmail(state.email))
                return .none
            case .binding(\.$password):
                state.isEnableNextButton = Validator.isEmail(state.email) && Validator.isPassword(state.password)
                print("変更:", state.password, "Validator.isPassword(state.password):", Validator.isPassword(state.password))
                return .none
            case .binding:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        .ifLet(\.$alert, action: \.alert)
        
        BindingReducer()
    }
}

extension MailAddressPassword {
    @Reducer(state: .equatable)
    public enum Path {
        case accountIdName(AccountIdName)
    }
}
