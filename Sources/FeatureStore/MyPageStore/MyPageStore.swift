//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/24.
//

import ComposableArchitecture

@Reducer
public struct MyPage {
    public struct State: Equatable {
        @BindingState public var isShownMailView: Bool = false
        
        public init() {}
    }
    
    public enum Action: BindableAction {
        case editProfileTapped
        case deleteAccountTapped
        case binding(BindingAction<State>)
        case delegate(Delegate)
        
        public enum Delegate: Equatable {
            case showEditProfile
            case dismiss
        }
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .editProfileTapped:
                return .send(.delegate(.showEditProfile))
                
            case .deleteAccountTapped:
                state.isShownMailView = true
                return .none
                
            case .binding:
                return .none
                
            case .delegate:
                return .none
            }
        }
        
        BindingReducer()
    }
}
