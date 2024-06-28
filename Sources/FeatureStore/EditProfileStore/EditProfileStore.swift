//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/06/28.
//

import Foundation
import ComposableArchitecture
import API
import UserDefaults

@Reducer
public struct EditProfile {
    public struct State: Equatable {
        @PresentationState public var alert: AlertState<Action.Alert>?
        @BindingState public var imageData: Data = Data()
        @BindingState public var accountId: String = ""
        @BindingState public var accountName: String = ""
        @BindingState public var isEnableSaveButton: Bool = false
        @BindingState public var isShownImagePicker: Bool = false
        
        public init() {}
    }
    
    public enum Action: BindableAction {
        // Event
        case initialize
        case didTapShowImagePicker
        case newImageSelected
        case whatIsAccountNameButtonTapped
        case whatIsAccountIdButtonTapped
        case saveButtonTapped
        
        // Response
        case getUserInfoResponse(Result<GetUserInfoResponse, Error>)
        case getProfileImageDataResponse(Result<Data, Error>)
        case uploadProfilePictureResponse(Result<UploadPictureResponse, Error>)
        case editUserProfileImageResponse(Result<EditUserProfileImageResponse, Error>)
        case editUserAccountInfoResponse(Result<EditUserAccountInfoResponse, Error>)
        
        // Navigation
        case dismiss
        case alert(PresentationAction<Alert>)
        case binding(BindingAction<State>)
        
        public enum Alert: Equatable {
            case failToRegisterAccountInfo
        }
    }
    
    public init() {}
    
    // MARK: - Dependencies
    @Dependency(\.getUserInfoClient) var getUserInfoClient
    @Dependency(\.uploadPictureClient) var uploadPictureClient
    @Dependency(\.editUserProfileImageClient) var editUserProfileImageClient
    @Dependency(\.editUserAccountInfoClient) var editUserAccountInfoClient
    @Dependency(\.userDefaults) var userDefaults
    @Dependency(\.dismiss) var dismiss
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            // MARK: - Action
            case .initialize:
                // ユーザー情報を取得する
                guard let sessionId = userDefaults.sessionId else {
                    // ここは通ってはいけない
                    fatalError()
                }
                
                return .run { send in
                    await send(.getUserInfoResponse(Result {
                        try await getUserInfoClient.send(sessionId: sessionId)
                    }))
                }
                
            case .didTapShowImagePicker:
                state.isShownImagePicker.toggle()
                return .none
                
            case .newImageSelected:
                guard let sessionId = userDefaults.sessionId else {
                    print("check: No Session ID ")
                    return .none
                }
                
                // プロフィール画像選択後、即保存のフローに乗せる
                return .run { [data = state.imageData] send in
                    await send(.uploadProfilePictureResponse(Result {
                        try await uploadPictureClient.upload(sessionId: sessionId, data: data)
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
                
            case .saveButtonTapped:
                guard let sessionId = userDefaults.sessionId else {
                    print("check: No Session ID ")
                    return .none
                }
                
                return .run { [accountId = state.accountId, accountName = state.accountName] send in
                    await send(.editUserAccountInfoResponse(Result {
                        try await editUserAccountInfoClient.send(
                            sessionId: sessionId,
                            accountId: accountId,
                            accountName: accountName
                        )
                    }))
                }
            
            // MARK: - Response
            case let .getUserInfoResponse(.success(response)):
                state.accountId = response.accountId
                state.accountName = response.accountName
                state.isEnableSaveButton = !state.accountId.isEmpty && !state.accountName.isEmpty
                
                return .run { send in
                    await send(.getProfileImageDataResponse(Result {
                        try Data(contentsOf: URL(string: response.accountImagePath)!)
                    }))
                }
                
            case let .getUserInfoResponse(.failure(error)):
                print("check: Error getUserInfoResponse = \(error.localizedDescription)")
                return .none
                
            case let .getProfileImageDataResponse(.success(response)):
                state.imageData = response
                return .none
                
            case let .getProfileImageDataResponse(.failure(error)):
                print("check: Error getProfileImageData = \(error.localizedDescription)")
                return .none
                
            case let .uploadProfilePictureResponse(.success(response)):
                guard let sessionId = userDefaults.sessionId else {
                    print("check: No Session ID ")
                    return .none
                }
                
                return .run { send in
                    await send(.editUserProfileImageResponse(Result {
                        try await editUserProfileImageClient.send(sessionId: sessionId, path: response.imagePath)
                    }))
                }
                
            case let .uploadProfilePictureResponse(.failure(error)):
                print("check: Error uploadProfilePicture = \(error.localizedDescription)")
                return .none
                
            case .editUserProfileImageResponse(.success(_)):
                state.alert = AlertState(title: TextState("登録完了"))
                return .none
                
            case let .editUserProfileImageResponse(.failure(error)):
                print("check: Error editUserProfileImage = \(error.localizedDescription)")
                return .none
                
            case .editUserAccountInfoResponse(.success(_)):
                print("check: SUCCESS editUserAccountInfoResponse")
                state.alert = AlertState(title: TextState("登録完了"))
                return .none
                
            case let .editUserAccountInfoResponse(.failure(error)):
                print("check: Error editUserAccountInfoResponse = \(error.localizedDescription)")
                state.alert = AlertState(title: TextState("登録失敗"))
                return .none
                
            // MARK: - Navigation
            case .dismiss:
                return .run { _ in await dismiss() }
                
            case .alert(.presented(.failToRegisterAccountInfo)):
                return .none
                
            case .alert:
                return .none
                
            case .binding(\.$accountId):
                state.isEnableSaveButton = !state.accountId.isEmpty && !state.accountName.isEmpty
                return .none
                
            case .binding(\.$accountName):
                state.isEnableSaveButton = !state.accountId.isEmpty && !state.accountName.isEmpty
                return .none
                
            case .binding:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
        
        BindingReducer()
    }
}

