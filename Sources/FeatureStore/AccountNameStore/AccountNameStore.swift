//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/01.
//

import ComposableArchitecture
import ProfileImageStore
import User

@Reducer
public struct AccountName {
    public struct State: Equatable {
        @PresentationState public var destination: Path.State?
        @BindingState public var name: String = ""
        @BindingState public var isEnableNextButton: Bool = false
        public var userRegist: UserRegist
        
        public init(userRegist: UserRegist) {
            self.userRegist = userRegist
        }
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
                state.destination = .profileImage(ProfileImage.State(userRegist: state.userRegist))
                return .none
            case .binding(\.$name):
                print("Account Name 変更:", state.name)
                state.userRegist.acountName = state.name
                return .none
            case .binding:
                return .none
            case .destination(_):
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        
        BindingReducer()
    }
}


extension AccountName {
    @Reducer(state: .equatable)
    public enum Path {
        case profileImage(ProfileImage)
    }
}
