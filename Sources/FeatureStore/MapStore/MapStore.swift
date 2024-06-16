//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/24.
//

import ComposableArchitecture
import MapKit
import PostStore
import PostDetailStore
import MyPageStore
import PostAnnotation
import API
import UserDefaults

@Reducer
public struct MapStore {
    public struct State: Equatable {
        @PresentationState public var destination: Path.State?
        @PresentationState public var postDetail: PostDetail.State?
        @BindingState public var isSelectPlaceMode: Bool = false
        @BindingState public var isShownPostDetailSheet: Bool = false
        @BindingState public var postAnnotations: [PostAnnotation] = []
        @BindingState public var isShowSuccessToast: Bool = false
        @BindingState public var text: String = ""
        
        public var centerRegion: CLLocationCoordinate2D?
        public init() {}
    }
    
    public enum Action: BindableAction {
        case floatingPlusButtonTapped
        case floatingHomeButtonTapped
        case annotationTapped(annotation: PostAnnotation)
        case postDetail(PresentationAction<PostDetail.Action>)
        case postDetailSheetDismiss
        case task
        case getPostsResponse(TaskResult<GetPostsResponse>)
        
        case showSuccessToast
        case hideSuccessToast
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
                response.posts.forEach { post in
                    state.postAnnotations.append(post.convert())
                }
                
                return .none
                
            case let .getPostsResponse(.failure(error)):
                
                // 仮
                state.postAnnotations.append(
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
                        createdAt: "2024-06-08 13:23:47 +0000"
                    )
                    .convert()
                )
                 
                
                print("check: failure getPostsResponse = \(state.postAnnotations.count)")
                
                
                return .none
                
            case .showSuccessToast:
                state.isShowSuccessToast = true
                return .none
                
            case .hideSuccessToast:
                state.isShowSuccessToast = false
                return .none
                
            case .floatingPlusButtonTapped:
                if state.isSelectPlaceMode == false {
                    state.isSelectPlaceMode = true
                }
                return .none
            case .floatingHomeButtonTapped:
                state.destination = .myPage(MyPage.State())
                return .none
            case let .annotationTapped(annotation):
                state.isShownPostDetailSheet = true
                state.postDetail = PostDetail.State(annotation: annotation)
                return .none
            case .postDetail(.presented(.delegate(.move))):
                return .none
            case .postDetail:
                return .none
            case .postDetailSheetDismiss:
                state.isShownPostDetailSheet = false
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
        .ifLet(\.$postDetail, action: \.postDetail) {
            PostDetail()
        }
        
        BindingReducer()
    }
}

extension MapStore {
    @Reducer(state: .equatable)
    public enum Path {
        case post(PostStore)
        case myPage(MyPage)
        case postDetail(PostDetail)
    }
}

extension GetPostEntity {
    func convert() -> PostAnnotation {
        return .init(
            postUserAccountName: self.postUserAccountName,
            postUserAccountId: self.postUserAccountId,
            postUserProfileImagePath: self.postUserProfileImagePath,
            postImagePath: self.postImagePath,
            coordinateX: self.coordinateX,
            coordinateY: self.coordinateY,
            freeText: self.freeText,
            startDatetime: self.startDatetime,
            endDatetime: self.endDatetime,
            createdAt: self.createdAt
        )
    }
}
