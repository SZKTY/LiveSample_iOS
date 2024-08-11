//
//  File.swift
//
//
//  Created by toya.suzuki on 2024/04/01.
//

import Foundation
import ComposableArchitecture
import API
import UserDefaults
import SelectModeStore

@Reducer
public struct ProfileImage {
    public struct State: Equatable {
        @PresentationState public var destination: Path.State?
        @PresentationState public var alert: AlertState<Action.Alert>?
        
        @BindingState public var isShownImagePicker: Bool = false
        @BindingState public var isShownSelfImagePicker: Bool = false
        @BindingState public var imageData: Data = Data()
        @BindingState public var isEnableNextButton: Bool = false
        @BindingState public var isBusy: Bool = false
        
        public init() {}
    }
    
    public enum Action: BindableAction {
        case skipButtonTapped
        case imageRemoveButtonTapped
        case didTapShowImagePicker
        case didTapShowSelfImagePicker
        case nextButtonTapped
        case uploadProfilePictureResponse(Result<UploadPictureResponse, Error>)
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
    @Dependency(\.uploadPictureClient) var uploadPictureClient
    @Dependency(\.registerProfilePictureClient) var registerProfilePictureClient
    @Dependency(\.userDefaults) var userDefaults
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .skipButtonTapped:
                state.destination = .selectMode(SelectMode.State())
                return .none
                
            case .imageRemoveButtonTapped:
                state.imageData = Data()
                return .none
                
            case .didTapShowImagePicker:
                state.isShownImagePicker.toggle()
                return .none
                
            case .didTapShowSelfImagePicker:
                state.isShownSelfImagePicker.toggle()
                return .none
                
            case .nextButtonTapped:
                if state.imageData == Data() {
                    state.destination = .selectMode(SelectMode.State())
                    return .none
                }
                
                guard let sessionId = userDefaults.sessionId, !state.isBusy else {
                    print("check: No Session ID ")
                    return .none
                }
                
                state.isBusy = true
                
                return .run { [data = state.imageData] send in
                    await send(.uploadProfilePictureResponse(Result {
                        try await uploadPictureClient.upload(sessionId: sessionId, data: data)
                    }))
                }
                
            case let .uploadProfilePictureResponse(.success(response)):
                guard let sessionId = userDefaults.sessionId else {
                    print("check: No Session ID ")
                    state.isBusy = false
                    return .none
                }
                
                return .run { send in
                    await send(.registerProfilePictureResponse(Result {
                        try await registerProfilePictureClient.send(sessionId: sessionId, path: response.imagePath)
                    }))
                }
                
            case let .uploadProfilePictureResponse(.failure(error)):
                state.alert = AlertState(title: TextState(error.asApiError?.message ?? error.localizedDescription))
                state.isBusy = false
                return .none
                
            case .registerProfilePictureResponse(.success(_)):
                state.destination = .selectMode(SelectMode.State())
                state.isBusy = false
                return .none
                
            case let .registerProfilePictureResponse(.failure(error)):
                state.alert = AlertState(title: TextState(error.asApiError?.message ?? error.localizedDescription))
                state.isBusy = false
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
