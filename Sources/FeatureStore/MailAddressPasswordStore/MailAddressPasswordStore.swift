//
//  MailAddressPassword.swift
//  
//
//  Created by toya.suzuki on 2024/03/24.
//

import Foundation
import ComposableArchitecture
import AccountIdNameStore
import SelectModeStore
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
        case getRequiredInfoResponse(Result<GetRequiredInfoResponse, Error>)
        case getUserInfoResponse(Result<GetUserInfoResponse, Error>)
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
    @Dependency(\.getRequiredInfoClient) var getRequiredInfoClient
    @Dependency(\.getUserInfoClient) var getUserInfoClient
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
                    await send(.getRequiredInfoResponse(Result {
                        try await getRequiredInfoClient.send(sessionId: response.sessionId)
                    }))
                    
                    // TODO: ログインAPIは問題なく叩けたが、必須情報取得・ユーザー情報取得で通信エラー等が発生し、アプリを終了した際（= 必須情報入力済みだがローカルにセッションIDしか入ってない際）の考慮が必要。起動時にもユーザー情報取得叩いてローカルを更新する？
                    
                }
            case let .loginResponse(.failure(error)):
                print("check: Login FAIL")
                
                
                // TODO: エラーハンドリング
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
                
                // TODO: エラーハンドリング
                state.alert = AlertState(title: TextState("登録失敗"))
                return .none
                
            case let .getRequiredInfoResponse(.success(response)):
                /*
                 アカウントID・アカウント名が取得できない場合は、アカウントID・アカウント名登録画面に遷移する
                 */
                if response.accountId.isEmpty || response.accountName.isEmpty {
                    state.destination = .accountIdName(AccountIdName.State())
                    return .none
                }
                
                /*
                 アカウントID・アカウント名は取得できているが、アカウント種別が取得できない場合は、アカウント種別登録画面に遷移する
                 */
                if response.accounType.isEmpty {
                    state.destination = .selectMode(SelectMode.State())
                    return .none
                }
                
                // 必須情報が全て入力済みであればユーザー情報を取得する
                guard let sessionId = userDefaults.sessionId else {
                    // ここは通ってはいけない
                    fatalError()
                }
                
                return .run { send in
                    await send(.getUserInfoResponse(Result {
                        try await getUserInfoClient.send(sessionId: sessionId)
                    }))
                }
                
            case let .getRequiredInfoResponse(.failure(error)):
                print("check: getRequiredInfo FAIL")
                
                // TODO: エラーハンドリング
                return .none
                
            case let .getUserInfoResponse(.success(response)):
                return .run { send in
                    await self.userDefaults.setUserId(response.userId)
                    await self.userDefaults.setAccountType(response.accountType)
                    
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.didFinishLogin, object: nil, userInfo: nil)
                    }
                }
                
            case let .getUserInfoResponse(.failure(error)):
                print("check: getUserInfo FAIL")
                
                // TODO: エラーハンドリング
                
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
        case selectMode(SelectMode)
    }
}

extension NSNotification {
    public static let didFinishLogin = Notification.Name.init("didFinishLogin")
}
