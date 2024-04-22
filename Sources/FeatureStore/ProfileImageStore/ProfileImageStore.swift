//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/01.
//

import Foundation
import ComposableArchitecture
import User
import SelectModeStore

@Reducer
public struct ProfileImage {
    public struct State: Equatable {
        @PresentationState public var destination: Path.State?
        @BindingState public var isShownImagePicker: Bool = false
        @BindingState public var isShownSelfImagePicker: Bool = false
        @BindingState public var imageData: Data = Data()
        @BindingState public var isEnableNextButton: Bool = false
        public var userRegist: UserRegist
        
        public init(userRegist: UserRegist) {
            self.userRegist = userRegist
        }
    }
    
    public enum Action: BindableAction {
        case didTapShowImagePicker
        case didTapShowSelfImagePicker
        case nextButtonTapped
        case binding(BindingAction<State>)
        case destination(PresentationAction<Path.Action>)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .didTapShowImagePicker:
                state.isShownImagePicker.toggle()
                return .none
            case .didTapShowSelfImagePicker:
                state.isShownSelfImagePicker.toggle()
                return .none
            case .nextButtonTapped:
                state.userRegist.profileImage = state.imageData
                state.destination = .selectMode(SelectMode.State(userRegist: state.userRegist))
                return .none
            case .binding:
                return .none
            case .destination(_):
                return .none
            }
        }
        
        BindingReducer()
    }
}

extension ProfileImage {
    @Reducer(state: .equatable)
    public enum Path {
        case selectMode(SelectMode)
    }
}
