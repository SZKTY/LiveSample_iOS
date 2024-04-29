//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/01.
//

import Foundation
import ComposableArchitecture
import SelectModeStore
import User
import API

@Reducer
public struct ProfileImage {
    public struct State: Equatable {
        @PresentationState public var destination: Path.State?
        @PresentationState public var alert: AlertState<Action.Alert>?
        
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
        case registerProfilePictureResponse(Result<RegisterProfilePictureResponse, Error>)
        case binding(BindingAction<State>)
        case destination(PresentationAction<Path.Action>)
        case alert(PresentationAction<Alert>)
        
        public enum Alert: Equatable {
            case failToRegisterProfilePicture
        }
    }
    
    public init() {}
    
    // MARK: - Dependencies
    @Dependency(\.registerProfilePictureClient) var registerProfilePictureClient
    
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
                return .run { [data = state.imageData] send in
                    await send(.registerProfilePictureResponse(Result {
                        try await registerProfilePictureClient.send(data: data)
                    }))
                }
                
            case let .registerProfilePictureResponse(.success(response)):
                state.userRegist.profileImage = state.imageData
                state.destination = .selectMode(SelectMode.State(userRegist: state.userRegist))
                return .none
                
            case let .registerProfilePictureResponse(.failure(error)):
                state.alert = AlertState(title: TextState("登録失敗"))
                return .none
                
            case .binding:
                return .none
            case .destination(_):
                return .none
                
            case .alert(.presented(.failToRegisterProfilePicture)):
                return .none
                
            case .alert:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        .ifLet(\.$alert, action: \.alert)
        
        BindingReducer()
    }
}

extension ProfileImage {
    @Reducer(state: .equatable)
    public enum Path {
        case selectMode(SelectMode)
    }
}
