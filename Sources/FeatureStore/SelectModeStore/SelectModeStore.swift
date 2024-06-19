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
        public var isEnableStartButton: Bool = false
        
        public init() {}
    }
    
    public enum Action: BindableAction {
        case didTapStartButton
        case registerAccountTypeResponse(Result<RegisterAccountTypeResponse, Error>)
        case alert(PresentationAction<Alert>)
        case binding(BindingAction<State>)
        
        public enum Alert: Equatable {
            case failToRegisterAccountType
        }
    }
    
    public init() {}
    
    // MARK: - Dependencies
    @Dependency(\.registerAccountTypeClient) var registerAccountTypeClient
    @Dependency(\.userDefaults) var userDefaults
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .didTapStartButton:
                guard let sessionId = userDefaults.sessionId else {
                    print("check: No Session ID ")
                    return .none
                }
                
                let type = state.isCheckedYes ? "artist" : "fan"
                
                return .run { send in
                    await userDefaults.setAccountType(type)
                    await send(.registerAccountTypeResponse(Result {
                        try await registerAccountTypeClient.send(sessionId: sessionId, accountType: type)
                    }))
                }
                
            case let .registerAccountTypeResponse(.success(response)):
                NotificationCenter.default.post(name: NSNotification.didFinishRegisterAccountInfo, object: nil, userInfo: nil)
                return .none
                
            case let .registerAccountTypeResponse(.failure(error)):
                state.alert = AlertState(title: TextState("登録失敗"))
                return .none
                
            case .alert(.presented(.failToRegisterAccountType)):
                return .none
                
            case .alert:
                return .none
                
            case .binding(\.$isCheckedYes):
                state.isCheckedNo = state.isCheckedYes
                state.isEnableStartButton = true
                return .none
                
            case .binding(\.$isCheckedNo):
                state.isCheckedYes = state.isCheckedNo
                state.isEnableStartButton = true
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
