//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/24.
//

import ComposableArchitecture
import PostStore
import MapKit
import API
import UserDefaults

@Reducer
public struct MapStore {
    public struct State: Equatable {
        @PresentationState public var destination: Path.State?
        @BindingState public var isSelectPlaceMode: Bool = false
        @BindingState public var isShowSuccessToast: Bool = false
        public var centerRegion: CLLocationCoordinate2D?
        public var posts: [GetPostEntity]?
        
        public init() {}
    }
    
    public enum Action: BindableAction {
        case task
        case getPostsResponse(TaskResult<GetPostsResponse>)
        
        case showSuccessToast
        case floatingButtonTapped
        case centerRegionChanged(region: CLLocationCoordinate2D)
        case cancelButtonTappedInSelectPlaceMode
        case confirmButtonTappedInSelectPlaceMode
        case destination(PresentationAction<Path.Action>)
        case binding(BindingAction<State>)
    }
    
    @Dependency(\.getPostsClient) var getPostsClient
    @Dependency(\.userDefaults) var userDefaults
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .task:
                guard let sessionId = userDefaults.sessionId else {
                    print("check: No Session ID ")
                    return .none
                }
                
                return .run { send in
                    await send(.getPostsResponse(TaskResult {
                        try await getPostsClient.send(sessionId: sessionId)
                    }))
                }
                
            case let .getPostsResponse(.success(response)):
                print("check: success getPostsResponse")
                state.posts = response.posts
                return .none
                
            case let .getPostsResponse(.failure(error)):
                print("check: failure getPostsResponse")
                
                // 仮
                state.posts = [
                    GetPostEntity(
                        postUserAccountName: "hoge",
                        postUserAccountId: "piyo",
                        postUserProfileImagePath: "hogehoge",
                        postImagePath: "piyopiyo",
                        coordinateX: "37.78476810434068",
                        coordinateY: "-122.40662076068551",
                        freeText: "huga",
                        startDatetime: "2024-06-08 13:23:47 +0000",
                        endDatetime: "2024-06-08 13:23:47 +0000",
                        createdAt: "2024-06-08 13:23:47 +0000")
                ]
                
                
                return .none
                
            case .showSuccessToast:
                state.isShowSuccessToast = true
                return .none
                
            case .floatingButtonTapped:
                if state.isSelectPlaceMode == false {
                    state.isSelectPlaceMode = true
                }
                return .none
            case let .centerRegionChanged(region):
                if state.isSelectPlaceMode {
                    state.centerRegion = region
                }
                return .none
            case .cancelButtonTappedInSelectPlaceMode:
                if state.isSelectPlaceMode == true {
                    state.isSelectPlaceMode = false
                }
                return .none
            case .confirmButtonTappedInSelectPlaceMode:
                if let center = state.centerRegion {
                    state.destination = .post(PostStore.State(center: center))
                    state.isSelectPlaceMode = false
                }
                return .none
            case .destination(_):
                return .none
            case .binding:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        
        BindingReducer()
    }
}

extension MapStore {
    @Reducer(state: .equatable)
    public enum Path {
        case post(PostStore)
    }
}
