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
import Validator

@Reducer
public struct ResetPasswordEnterNewPassword: Sendable {
    public struct State: Equatable {
        @PresentationState public var alert: AlertState<Action.Alert>?
        
        public var passwordResetToken: String?
        @BindingState public var password: String = ""
        @BindingState public var isEnableNextButton: Bool = false
        @BindingState public var isBusy: Bool = false
        
        public init(passwordResetToken: String?) {
            self.passwordResetToken = passwordResetToken
        }
    }
    
    public enum Action: BindableAction {
        case nextButtonTapped
        case resetPasswordResponse(Result<ResetPasswordResponse, Error>)
        case closeButtonTapped
        case alert(PresentationAction<Alert>)
        case binding(BindingAction<State>)
        case didChangePassword
        
        public enum Alert: Equatable {
            case failToRegisterNewPassword
        }
    }
    
    public init() {}
    
    // MARK: - Dependencies
    @Dependency(\.resetPasswordClient) var resetPasswordClient
    @Dependency(\.userDefaults) var userDefaults
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .nextButtonTapped:
                guard !state.isBusy, let passwordResetToken = state.passwordResetToken else { return .none }
                state.isBusy = true
                
                return .run { [passwordResetToken = passwordResetToken, password = state.password] send in
                    await send(.resetPasswordResponse(Result {
                        try await resetPasswordClient.send(passwordResetToken: passwordResetToken, password: password)
                    }))
                }
                
            case .closeButtonTapped:
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.changeToResetPassword, object: nil, userInfo: nil)
                }
                
                return .none
                
            case let .resetPasswordResponse(.success(response)):
                print("check: Send AuthenticationCode SUCCESS")
                state.isBusy = false
                
                return .run { send in
                    await send(.closeButtonTapped)
                }

            case let .resetPasswordResponse(.failure(error)):
                print("check: Send AuthenticationCode FAIL")
                state.alert = AlertState(title: TextState(error.asApiError?.message ?? error.localizedDescription))
                state.isBusy = false

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
        .ifLet(\.$alert, action: \.alert)
        
        BindingReducer()
    }
}

extension NSNotification {
    public static let changeToResetPassword = Notification.Name.init("changeToResetPassword")
}
