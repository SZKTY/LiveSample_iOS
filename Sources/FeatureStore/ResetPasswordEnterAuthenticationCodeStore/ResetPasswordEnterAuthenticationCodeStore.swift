//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/11/24.
//

import Foundation
import ComposableArchitecture
import API
import UserDefaults

@Reducer
public struct ResetPasswordEnterAuthenticationCode: Sendable {
    public struct State: Equatable {
        @PresentationState public var alert: AlertState<Action.Alert>?
        
        @BindingState public var email: String = ""
        @BindingState public var code: String = ""
        @BindingState public var isEnableNextButton: Bool = false
        @BindingState public var isBusy: Bool = false
        
        public init(email: String) {
            self.email = email
        }
    }
    
    public enum Action: BindableAction {
        case nextButtonTapped
        case resetPasswordExecuteVerificationResponse(Result<ResetPasswordExecuteVerificationResponse, Error>)
        case alert(PresentationAction<Alert>)
        case binding(BindingAction<State>)
        case didChangeAuthenticationCode
        
        public enum Alert: Equatable {
            case failToSendAuthenticationCode
        }
    }
    
    public init() {}
    
    // MARK: - Dependencies
    @Dependency(\.resetPasswordExecuteVerificationClient) var resetPasswordExecuteVerificationClient
    @Dependency(\.userDefaults) var userDefaults
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .nextButtonTapped:
                guard !state.isBusy else { return .none }
                state.isBusy = true
                
                return .run { [email = state.email, code = state.code] send in
                    await send(.resetPasswordExecuteVerificationResponse(Result {
                        try await resetPasswordExecuteVerificationClient.send(email: email, code: code)
                    }))
                }
                
            case let .resetPasswordExecuteVerificationResponse(.success(response)):
                print("check: Send AuthenticationCode SUCCESS")
                state.isBusy = false
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(
                        name: NSNotification.changeToResetPassword,
                        object: nil,
                        userInfo: ["passwordResetToken": response.passwordResetToken])
                }
                
                return .none

            case let .resetPasswordExecuteVerificationResponse(.failure(error)):
                print("check: Send AuthenticationCode FAIL")
                state.alert = AlertState(title: TextState(error.asApiError?.message ?? error.localizedDescription))
                state.isBusy = false

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
        .ifLet(\.$alert, action: \.alert)
        
        BindingReducer()
    }
}

extension NSNotification {
    public static let changeToResetPassword = Notification.Name.init("changeToResetPassword")
}
