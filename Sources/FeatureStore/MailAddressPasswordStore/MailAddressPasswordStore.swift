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
import UserDefaults
import Validator

@Reducer
public struct MailAddressPassword: Sendable {
    public struct State: Equatable {
        @PresentationState public var destination: Path.State?
        @PresentationState public var alert: AlertState<Action.Alert>?
        
        @BindingState public var email: String = ""
        @BindingState public var password: String = ""
        @BindingState public var isEnableNextButton: Bool = false
        
        public var isLogin: Bool
        
        public init(isLogin: Bool) {
            self.isLogin = isLogin
        }
    }
    
    public enum Action: BindableAction {
        case nextButtonTapped
        case loginResponse(Result<LoginResponse, Error>)
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
    @Dependency(\.loginClient) var loginClient
    @Dependency(\.userDefaults) var userDefaults
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .nextButtonTapped:
                return .run { [
                    isLogin = state.isLogin,
                    email = state.email,
                    password = state.password] send in
                    if isLogin {
                        await send(.loginResponse(Result {
                            try await loginClient.send(email: email, password: password)
                        }))
                    } else {
                        await send(.issueAccountResponse(Result {
                            try await issueAccountClient.send(email: email, password: password)
                        }))
                    }
                }
            case let .loginResponse(.success(response)):
                print("check: Login SUCCESS")
                return .run { send in
                    await self.userDefaults.setSessionId(response.sessionId)
                    
                    // 画面遷移に繋がるためメインスレッドに流す
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.didFinishLogin, object: nil, userInfo: nil)
                    }
                }
            case let .loginResponse(.failure(error)):
                print("check: Login FAIL")
                // エラーハンドリング
                state.alert = AlertState(title: TextState("ログイン失敗"))
                return .none
            case let .issueAccountResponse(.success(response)):
                print("check: issueAccount SUCCESS")
                state.destination = .accountIdName(AccountIdName.State())
                return .run { send in
                    await self.userDefaults.setSessionId(response.sessionId)
                    await self.userDefaults.setUserId(response.userId)
                }
                
            case let .issueAccountResponse(.failure(error)):
                print("check: issueAccount FAIL")
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

extension NSNotification {
    public static let didFinishLogin = Notification.Name.init("didFinishLogin")
}
