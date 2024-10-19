//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/06/13.
//

import ComposableArchitecture
import MapKit
import DateUtils
import Share
import API
import UserDefaults
import PostAnnotation
import Constants

@Reducer
public struct PostDetail {
    public struct State: Equatable {
        @PresentationState public var alert: AlertState<Action.Alert>?
        @PresentationState public var actionSheet: ActionSheetState<Action.ActionSheet>?
        @BindingState public var isShownActionSheet: Bool = false
        @BindingState public var isShownMailView: Bool = false
        @BindingState public var isShowSharePopover: Bool = false
        public var annotation: PostAnnotation
        public var isMine: Bool = true
        public var shareRenderedImageData: Data?
        
        public var dateString: String {
            let date = DateUtils.dateFromString(string: annotation.startDatetime, format: "yyyy-MM-dd'T'HH:mm:ssZ")
            let dateString = DateUtils.stringFromDate(date: date, format: "MM/dd（EEE）")
            return dateString
        }
        
        public var startToFinishTimeString: String {
            let startDate = DateUtils.dateFromString(string: annotation.startDatetime, format: "yyyy-MM-dd'T'HH:mm:ssZ")
            let endDate = DateUtils.dateFromString(string: annotation.endDatetime, format: "yyyy-MM-dd'T'HH:mm:ssZ")
            let startTimeString = DateUtils.stringFromDate(date: startDate, format: "HH:mm")
            let endTimeString = DateUtils.stringFromDate(date: endDate, format: "HH:mm")
            return startTimeString + " ~ " + endTimeString
        }
        
        public init(annotation: PostAnnotation) {
            self.annotation = annotation
        }
    }
    
    public enum Action: BindableAction {
        case initialize
        case dismiss
        case squareAndArrowUpButtonTapped(Data)
        case ellipsisButtonTapped
        case reportButtonTapped
        case blockButtonTapped
        case deletePostButtonTapped
        case getBlockUserResponse(Result<BlockUserResponse, Error>)
        case getDeletePostResponse(Result<DeletePostResponse, Error>)
        case shareInstagramResponse(Result<Void, Error>)
        case delegate(Delegate)
        case binding(BindingAction<State>)
        case alert(PresentationAction<Alert>)
        case actionSheet(PresentationAction<ActionSheet>)
        
        public enum Alert: Equatable {
            case failToDeletePost
            case failToBlockUser
        }
        
        public enum ActionSheet: Equatable {
            case instagramTapped
            case XTapped
        }
        
        public enum Delegate: Equatable {
            case removePost(annotation: PostAnnotation)
            case block(annotation: PostAnnotation)
            case dismiss
            case move
        }
    }
    
    @Dependency(\.blockUserClient) var blockUser
    @Dependency(\.deletePostClient) var deletePost
    @Dependency(\.userDefaults) var userDefaults
    @Dependency(\.snsClient) var snsClient
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .initialize:
                guard let userId = userDefaults.userId else {
                    print("check: No User ID ")
                    return .none
                }
                
                // 自分の投稿かどうか判断する
                state.isMine = userId == state.annotation.postUserId
                
                // マップの位置を調整する
                return .send(.delegate(.move))
                
            case .dismiss:
                return .send(.delegate(.dismiss))
                
            case let .squareAndArrowUpButtonTapped(data):
                state.shareRenderedImageData = data
                state.actionSheet = .init(
                    title: TextState("シェア"),
                    buttons: [
                        .default(.init("Instagram Story"), action: .send(.instagramTapped)),
                        .default(.init("その他"), action: .send(.XTapped)),
                        .cancel(TextState("キャンセル"))
                    ]
                )
                
                return .none
                
            case .ellipsisButtonTapped:
                state.isShownActionSheet = true
                return .none
                
            case .deletePostButtonTapped:
                guard let sessionId = userDefaults.sessionId else {
                    print("check: No Session ID ")
                    return .none
                }
                let deletePostId = state.annotation.postId
                
                return .run { send in
                    await send(.getDeletePostResponse( Result {
                        try await deletePost.send(sessionId: sessionId, deletePostId: deletePostId)
                    }))
                }
                
            case .getDeletePostResponse(.success(_)):
                return .send(.delegate(.removePost(annotation: state.annotation)))
                
            case let .getDeletePostResponse(.failure(error)):
                state.alert = .init(
                    title: .init(error.localizedDescription),
                    buttons: [
                        .default(.init("リトライ"), action: .send(.failToDeletePost)),
                        .cancel(TextState("キャンセル"))
                    ]
                )
                return .none
                
            case .shareInstagramResponse(.success()):
                return .none
                
            case let .shareInstagramResponse(.failure(error)):
                state.alert = .init(
                    title: .init(error.localizedDescription),
                    buttons: [
                        .cancel(TextState("キャンセル"))
                    ]
                )
                return .none
                
            case .reportButtonTapped:
                state.isShownMailView = true
                return .none
                
            case .blockButtonTapped:
                guard let sessionId = userDefaults.sessionId else {
                    print("check: No Session ID ")
                    return .none
                }
                let blockUserId = state.annotation.postUserId
                
                return .run { send in
                    await send(.getBlockUserResponse( Result {
                        try await blockUser.send(sessionId: sessionId, blockUserId: blockUserId)
                    }))
                }
                
            case .getBlockUserResponse(.success(_)):
                return .send(.delegate(.block(annotation: state.annotation)))
                
            case let .getBlockUserResponse(.failure(error)):
                state.alert = .init(
                    title: .init(error.localizedDescription),
                    buttons: [
                        .default(.init("リトライ"), action: .send(.failToBlockUser)),
                        .cancel(TextState("キャンセル"))
                    ]
                )
                return .none
                
            case .delegate:
                return .none
                
            case .binding:
                return .none
                
            case .alert(.presented(.failToDeletePost)):
                return .run { send in
                    await send(.deletePostButtonTapped)
                }
                
            case .alert(.presented(.failToBlockUser)):
                return .run { send in
                    await send(.blockButtonTapped)
                }
                
            case .alert:
                return .none
                
            case .actionSheet(.presented(.instagramTapped)):
                guard let url = Constants.shared.storeUrl,
                      let data = state.shareRenderedImageData else { return .none }
                
                return .run { send in
                    await send(.shareInstagramResponse( Result {
                        try await snsClient.shareInstagramStorie(data, "#000823", "#09112F", url)
                    }))
                }
                
            case .actionSheet(.presented(.XTapped)):
                guard let imageData = state.shareRenderedImageData else { return .none }
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    state.isShowSharePopover = true
                } else {
                    snsClient.showShareView(
                        imageData: imageData,
                        title: state.annotation.freeText,
                        url: Constants.shared.storeUrl
                    )
                }
                
                return .none
                
            case .actionSheet:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
        
        BindingReducer()
    }
}
