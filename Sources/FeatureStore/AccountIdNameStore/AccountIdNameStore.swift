//
//  File.swift
//
//
//  Created by toya.suzuki on 2024/04/01.
//

import ComposableArchitecture
import ProfileImageStore
import User
import API

@Reducer
public struct AccountIdName {
    public struct State: Equatable {
        @PresentationState public var destination: Path.State?
        @PresentationState public var alert: AlertState<Action.Alert>?
        @BindingState public var accountId: String = ""
        @BindingState public var accountName: String = ""
        @BindingState public var isEnableNextButton: Bool = false
        
        public var userRegist: UserRegist = UserRegist()
        
        public init() {}
    }
    
    public enum Action: BindableAction {
        case nextButtonTapped
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
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .nextButtonTapped:
                return .run { [accountId = state.accountId, accountName = state.accountName] send in
                    await send(.registerAccountInfoResponse(Result {
                        try await registerAccountInfoClient.send(accountId: accountId, accountName: accountName)
                    }))
                }
                
            case let .registerAccountInfoResponse(.success(response)):
                state.destination = .profileImage(ProfileImage.State(userRegist: state.userRegist))
                return .none
                
            case let .registerAccountInfoResponse(.failure(error)):
                return .none
                
            case .destination:
                return .none
                
            case .alert(.presented(.failToRegisterAccountInfo)):
                return .none
                
            case .alert:
                return .none
                
            case .binding(\.$accountId):
                print("Account ID 変更:", state.accountId)
                state.isEnableNextButton = !state.accountId.isEmpty && !state.accountName.isEmpty
                state.userRegist.accountId = state.accountId
                return .none
                
            case .binding(\.$accountName):
                print("Account Name 変更:", state.accountName)
                state.isEnableNextButton = !state.accountId.isEmpty && !state.accountName.isEmpty
                state.userRegist.accountName = state.accountName
                return .none
                
            case .binding:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        
        BindingReducer()
    }
}


extension AccountIdName {
    @Reducer(state: .equatable)
    public enum Path {
        case profileImage(ProfileImage)
    }
}
