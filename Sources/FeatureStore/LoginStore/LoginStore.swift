//
//  Login.swift
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
public struct Login: Sendable {
    public struct State: Equatable {
        @PresentationState public var destination: Path.State?
        @PresentationState public var alert: AlertState<Action.Alert>?
        
        @BindingState public var email: String = ""
        @BindingState public var password: String = ""
        @BindingState public var isEnableNextButton: Bool = false
        @BindingState public var isBusy: Bool = false
        
        public init() {}
    }
    
    public enum Action: BindableAction {
        case nextButtonTapped
        case loginResponse(Result<LoginResponse, Error>)
        case getRequiredInfoResponse(Result<GetRequiredInfoResponse, Error>)
        case getUserInfoResponse(Result<GetUserInfoResponse, Error>)
        case destination(PresentationAction<Path.Action>)
        case alert(PresentationAction<Alert>)
        case binding(BindingAction<State>)
        case didChangeEmail
        case didChangePassword
        
        public enum Alert: Equatable {
            case failToLogin
        }
    }
    
    public init() {}
    
    // MARK: - Dependencies
    @Dependency(\.loginClient) var loginClient
    @Dependency(\.getRequiredInfoClient) var getRequiredInfoClient
    @Dependency(\.getUserInfoClient) var getUserInfoClient
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
                    await send(.loginResponse(Result {
                        try await loginClient.send(email: email, password: password)
                    }))
                }
                
            case let .loginResponse(.success(response)):
                print("check: Login SUCCESS")
                return .run { send in
                    await self.userDefaults.setSessionId(response.sessionId)
                    await send(.getRequiredInfoResponse(Result {
                        try await getRequiredInfoClient.send(sessionId: response.sessionId)
                    }))
                    
                }
            case let .loginResponse(.failure(error)):
                // TODO: エラーハンドリング
                
                print("check: Login FAIL")
                state.alert = AlertState(title: TextState(error.asApiError?.message ?? error.localizedDescription))
                state.isBusy = false
                
                return .none
                
            case let .getRequiredInfoResponse(.success(response)):
                /*
                 アカウントID・アカウント名が取得できない場合は、アカウントID・アカウント名登録画面に遷移する
                 */
                if response.accountId.isEmpty || response.accountName.isEmpty {
                    state.destination = .accountIdName(AccountIdName.State())
                    state.isBusy = false
                    return .none
                }
                
                /*
                 アカウントID・アカウント名は取得できているが、アカウント種別が取得できない場合は、アカウント種別登録画面に遷移する
                 */
                if response.accountType.isEmpty {
                    state.destination = .selectMode(SelectMode.State())
                    state.isBusy = false
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
                // TODO: エラーハンドリング
                
                print("check: getRequiredInfo FAIL")
                state.isBusy = false
                state.alert = AlertState(title: TextState(error.asApiError?.message ?? error.localizedDescription))
                return .none
                
            case let .getUserInfoResponse(.success(response)):
                state.isBusy = false
                
                return .run { send in
                    await self.userDefaults.setUserId(response.userId)
                    await self.userDefaults.setAccountType(response.accountType)
                    
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.didFinishLogin, object: nil, userInfo: nil)
                    }
                }
                
            case let .getUserInfoResponse(.failure(error)):
                // TODO: エラーハンドリング
                
                print("check: getUserInfo FAIL")
                state.isBusy = false
                state.alert = AlertState(title: TextState(error.asApiError?.message ?? error.localizedDescription))
                return .none
                
            case .destination:
                return .none
                
            case .alert(.presented(.failToLogin)):
                return .none
                
            case .alert:
                return .none
            case .binding:
                return .none
                
            case .didChangeEmail:
                state.isEnableNextButton = Validator.isEmail(state.email) && Validator.isPassword(state.password)
                print("変更:", state.email, "Validator.isEmail(state.email):", Validator.isEmail(state.email))
                return .none
                
            case .didChangePassword:
                state.isEnableNextButton = Validator.isEmail(state.email) && Validator.isPassword(state.password)
                print("変更:", state.password, "Validator.isPassword(state.password):", Validator.isPassword(state.password))
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        .ifLet(\.$alert, action: \.alert)
        
        BindingReducer()
    }
}

extension Login {
    @Reducer(state: .equatable)
    public enum Path {
        case accountIdName(AccountIdName)
        case selectMode(SelectMode)
    }
}

extension NSNotification {
    public static let didFinishLogin = Notification.Name.init("didFinishLogin")
}
