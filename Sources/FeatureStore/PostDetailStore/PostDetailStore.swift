//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/06/13.
//

import ComposableArchitecture
import MapKit
import API
import UserDefaults
import PostAnnotation

class DateUtils {
    class func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }

    class func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}

@Reducer
public struct PostDetail {
    public struct State: Equatable {
        @BindingState public var isShownActionSheet: Bool = false
        @BindingState public var isShownMailView: Bool = false
        public let annotation: PostAnnotation
        public var isMine: Bool = true
        
        public var dateString: String {
            let date = DateUtils.dateFromString(string: annotation.startDatetime, format: "yyyy/MM/dd HH:mm:ss Z")
            let dateString = DateUtils.stringFromDate(date: date, format: "MM/dd（EEE）")
            return dateString
        }
        
        public var startToFinishTimeString: String {
            let startDate = DateUtils.dateFromString(string: annotation.startDatetime, format: "yyyy/MM/dd HH:mm:ss Z")
            let endDate = DateUtils.dateFromString(string: annotation.endDatetime, format: "yyyy/MM/dd HH:mm:ss Z")
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
        case ellipsisButtonTapped
        case reportButtonTapped
        case blockButtonTapped
        case deletePostButtonTapped
        case getBlockUserResponse(Result<BlockUserResponse, Error>)
        case getDeletePostResponse(Result<DeletePostResponse, Error>)
        case delegate(Delegate)
        case binding(BindingAction<State>)
        
        public enum Delegate: Equatable {
            case dismiss
            case move
        }
    }
    
    @Dependency(\.blockUserClient) var blockUser
    @Dependency(\.deletePostClient) var deletePost
    @Dependency(\.userDefaults) var userDefaults
    
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
                // TODO: Account ID => User ID に変更する
                state.isMine = "\(userId)" == state.annotation.postUserAccountId
                
                // マップの位置を調整する
                return .send(.delegate(.move))
                
            case .dismiss:
                return .send(.delegate(.dismiss))
                
            case .ellipsisButtonTapped:
                state.isShownActionSheet = true
                return .none
                
            case .deletePostButtonTapped:
                guard let sessionId = userDefaults.sessionId else {
                    print("check: No Session ID ")
                    return .none
                }
                
                return .run { send in
                    await send(.getDeletePostResponse( Result {
                        // TODO: Post ID
                        try await deletePost.send(sessionId: sessionId, deletePostId: 1)
                    }))
                }
                
            case let .getDeletePostResponse(.success(response)):
                return .send(.delegate(.dismiss))
                
            case let .getDeletePostResponse(.failure(error)):
                return .none
                
            case .reportButtonTapped:
                state.isShownMailView = true
                return .none
                
            case .blockButtonTapped:
                guard let sessionId = userDefaults.sessionId else {
                    print("check: No Session ID ")
                    return .none
                }
                
                return .run { send in
                    await send(.getBlockUserResponse( Result {
                        // TODO: User Id
                        try await blockUser.send(sessionId: sessionId, blockUserId: 1)
                    }))
                }
                
            case let .getBlockUserResponse(.success(response)):
                return .send(.delegate(.dismiss))
                
            case let .getBlockUserResponse(.failure(error)):
                return .none
                
            case .delegate:
                return .none
                
            case .binding:
                return .none
            }
        }
        BindingReducer()
    }
}
