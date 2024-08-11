//
//  File.swift
//
//
//  Created by toya.suzuki on 2024/04/01.
//

import Foundation
import ComposableArchitecture
import API
import UserDefaults

@Reducer
public struct SelectMode {
    public struct State: Equatable {
        @PresentationState public var alert: AlertState<Action.Alert>?
        
        @BindingState public var isCheckedYes: Bool = false
        @BindingState public var isCheckedNo: Bool = false
        @BindingState public var isAgree: Bool = false
        @BindingState public var isBusy: Bool = false
        
        public var isEnableStartButton: Bool = false
        
        public init() {}
    }
    
    public enum Action: BindableAction {
        case agreeButtonTapped
        case startButtonTapped
        case registerAccountTypeResponse(Result<RegisterAccountTypeResponse, Error>)
        case getUserInfoResponse(Result<GetUserInfoResponse, Error>)
        case alert(PresentationAction<Alert>)
        case binding(BindingAction<State>)
        
        public enum Alert: Equatable {
            case failToRegisterAccountType
        }
    }
    
    public init() {}
    
    // MARK: - Dependencies
    @Dependency(\.registerAccountTypeClient) var registerAccountTypeClient
    @Dependency(\.getUserInfoClient) var getUserInfoClient
    @Dependency(\.userDefaults) var userDefaults
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .agreeButtonTapped:
                state.isAgree.toggle()
                state.isEnableStartButton = state.isAgree && (state.isCheckedYes || state.isCheckedNo)
                return .none
                
            case .startButtonTapped:
                guard let sessionId = userDefaults.sessionId, !state.isBusy else {
                    print("check: No Session ID ")
                    return .none
                }
                
                state.isBusy = true
                let type = state.isCheckedYes ? "artist" : "fan"
                
                return .run { send in
                    // アカウント種別をサーバーに登録する
                    await send(.registerAccountTypeResponse(Result {
                        try await registerAccountTypeClient.send(sessionId: sessionId, accountType: type)
                    }))
                }
                
            case .registerAccountTypeResponse(.success(_)):
                guard let sessionId = userDefaults.sessionId else {
                    print("check: No Session ID ")
                    state.isBusy = false
                    return .none
                }
                
                let type = state.isCheckedYes ? "artist" : "fan"
                
                return .run { send in
                    // アカウント種別をローカルに保存する
                    await userDefaults.setAccountType(type)
                    
                    await send(.getUserInfoResponse(Result {
                        try await getUserInfoClient.send(sessionId: sessionId)
                    }))
                }
                
            case let .registerAccountTypeResponse(.failure(error)):
                state.alert = AlertState(title: TextState(error.asApiError?.message ?? error.localizedDescription))
                state.isBusy = false
                return .none
                
            case let .getUserInfoResponse(.success(response)):
                state.isBusy = false
                
                return .run { send in
                    await self.userDefaults.setUserId(response.userId)
                    await self.userDefaults.setAccountType(response.accountType)
                    
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.didFinishRegisterAccountInfo, object: nil, userInfo: nil)
                    }
                }
                
            case let .getUserInfoResponse(.failure(error)):
                // TODO: エラーハンドリング
                
                print("check: getUserInfo FAIL")
                state.alert = AlertState(title: TextState(error.asApiError?.message ?? error.localizedDescription))
                state.isBusy = false
                return .none
                
            case .alert(.presented(.failToRegisterAccountType)):
                return .none
                
            case .alert:
                return .none
                
            case .binding(\.$isCheckedYes):
                state.isCheckedNo = state.isCheckedYes
                state.isEnableStartButton = state.isAgree
                return .none
                
            case .binding(\.$isCheckedNo):
                state.isCheckedYes = state.isCheckedNo
                state.isEnableStartButton = state.isAgree
                return .none
                
            case .binding(\.$isAgree):
                state.isEnableStartButton = !state.isAgree && (state.isCheckedYes || state.isCheckedNo)
                return .none
                
            case .binding:
                return .none
            }
        }
        
        BindingReducer()
    }
}

extension NSNotification {
    public static let didFinishRegisterAccountInfo = Notification.Name.init("didFinishRegisterAccountInfo")
}
