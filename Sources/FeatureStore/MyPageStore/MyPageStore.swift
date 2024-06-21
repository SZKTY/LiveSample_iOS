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
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .editProfileTapped:
                return .none
                
            case .deleteAccountTapped:
                state.isShownMailView = true
                return .none
                
            case .binding:
                return .none
            }
        }
        
        BindingReducer()
    }
}
