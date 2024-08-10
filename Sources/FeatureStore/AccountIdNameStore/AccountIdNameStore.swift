//
//  File.swift
//
//
//  Created by toya.suzuki on 2024/04/01.
//

import ComposableArchitecture
import ProfileImageStore
import API
import UserDefaults

@Reducer
public struct AccountIdName {
    public struct State: Equatable {
        @PresentationState public var destination: Path.State?
        @PresentationState public var alert: AlertState<Action.Alert>?
        @BindingState public var accountId: String = ""
        @BindingState public var accountName: String = ""
        @BindingState public var isEnableNextButton: Bool = false
        
        public init() {}
    }
    
    public enum Action: BindableAction {
        case nextButtonTapped
        case whatIsAccountNameButtonTapped
        case whatIsAccountIdButtonTapped
        case registerAccountInfoResponse(Result<RegisterAccountInfoResponse, Error>)
        case destination(PresentationAction<Path.Action>)
        case alert(PresentationAction<Alert>)
        case binding(BindingAction<State>)
        
        public enum Alert: Equatable {
            case failToRegisterAccountInfo
        }
    }
    
    public init() {}
    
    // MARK: - Dependencies
    @Dependency(\.registerAccountInfoClient) var registerAccountInfoClient
    @Dependency(\.userDefaults) var userDefaults
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .nextButtonTapped:
                guard let sessionId = userDefaults.sessionId else {
                    print("check: No Session ID ")
                    return .none
                }
                
                return .run { [accountId = state.accountId, accountName = state.accountName] send in
                    await send(.registerAccountInfoResponse(Result {
                        try await registerAccountInfoClient.send(sessionId: sessionId, accountId: accountId, accountName: accountName)
                    }))
                }
                
            case .whatIsAccountNameButtonTapped:
                state.alert = AlertState(
                    title: TextState("アカウント名について"),
                    message: TextState("あなたのプロフィールに\n表示されるハンドルネームです。\nアーティスト名など任意の名前を\n設定できます。")
                )
                return .none
                
            case .whatIsAccountIdButtonTapped:
                state.alert = AlertState(
                    title: TextState("アカウントIDについて"),
                    message: TextState("（サービス名）上であなたを一意に\n識別するIDです。\n他のユーザーと重複しないように\n設定いただきます。\n（アカウントIDもプロフィールに表示されます）")
                )
                return .none
                
            case let .registerAccountInfoResponse(.success(response)):
                print("check: SUCCESS")
                state.destination = .profileImage(ProfileImage.State())
                return .none
                
            case let .registerAccountInfoResponse(.failure(error)):
                print("check: FAIL")
                state.alert = AlertState(title: TextState(error.asApiError?.message ?? error.localizedDescription))
                return .none
                
            case .destination:
                return .none
                
            case .alert(.presented(.failToRegisterAccountInfo)):
                return .none
                
            case .alert:
                return .none
                
            case .binding(\.$accountId):
                // TODO: バリデーション
                state.isEnableNextButton = !state.accountId.isEmpty && !state.accountName.isEmpty
                return .none
                
            case .binding(\.$accountName):
                // TODO: バリデーション
                state.isEnableNextButton = !state.accountId.isEmpty && !state.accountName.isEmpty
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


extension AccountIdName {
    @Reducer(state: .equatable)
    public enum Path {
        case profileImage(ProfileImage)
    }
}
