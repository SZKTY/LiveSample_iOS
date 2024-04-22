//
//  AccountId.swift
//
//
//  Created by toya.suzuki on 2024/04/01.
//

import ComposableArchitecture
import User
import AccountNameStore

@Reducer
public struct AccountId {
    public struct State: Equatable {
        @PresentationState public var destination: Path.State?
        @BindingState public var accountId: String = ""
        public var isEnableNextButton: Bool = false
        public var userRegist: UserRegist = UserRegist()
        
        public init() {}
    }
    
    public enum Action: BindableAction {
        case nextButtonTapped
        case destination(PresentationAction<Path.Action>)
        case binding(BindingAction<State>)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .nextButtonTapped:
                state.destination = .accountName(AccountName.State(userRegist: state.userRegist))
                return .none
                
            case .destination:
                return .none
                
            case .binding(\.$accountId):
                print("Account ID 変更:", state.accountId)
                state.userRegist.accountId = state.accountId
                return .none
                
            case .binding:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        
        BindingReducer()
    }
}


extension AccountId {
    @Reducer(state: .equatable)
    public enum Path {
        case accountName(AccountName)
    }
}
