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
import EditProfileStore
import PostAnnotation
import API
import UserDefaults

@Reducer
public struct MapStore {
    public struct State: Equatable {
        @PresentationState public var destination: Path.State?
        @PresentationState public var postDetail: PostDetail.State?
        @PresentationState public var myPage: MyPage.State?
        @PresentationState public var alert: AlertState<Action.Alert>?
        
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
        case myPage(PresentationAction<MyPage.Action>)
        case myPageSheetDismiss
        case task
        case getPostsResponse(TaskResult<GetPostsResponse>)
        case showSuccessToast
        case hideSuccessToast
        case centerRegionChanged(region: CLLocationCoordinate2D)
        case cancelButtonTappedInSelectPlaceMode
        case confirmButtonTappedInSelectPlaceMode
        case destination(PresentationAction<Path.Action>)
        case binding(BindingAction<State>)
        case alert(PresentationAction<Alert>)
        
        public enum Alert: Equatable {
            case failToGetPosts
        }
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
                guard let posts = response.posts else { return .none }
                state.postAnnotations = posts.map { $0.convert() }
                return .none
                
            case let .getPostsResponse(.failure(error)):
                print("check: failure getPostsResponse")
                state.alert = .init(
                    title: .init(error.localizedDescription),
                    buttons: [
                        .default(.init("リトライ"), action: .send(.failToGetPosts))
                    ]
                )
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
                state.myPage = MyPage.State()
                return .none
                
            case let .annotationTapped(annotation):
                state.isShownPostDetailSheet = true
                state.postDetail = PostDetail.State(annotation: annotation)
                return .none
            case .postDetail(.presented(.delegate(.move))):
                return .none
                
            case let .postDetail(.presented(.delegate(.removePost(postAnnotation)))):
                state.isShownPostDetailSheet = false
                state.postDetail = nil
                
                guard let sessionId = userDefaults.sessionId else {
                    print("check: No Session ID ")
                    return .none
                }
                
                return .run { send in
                    await send(.getPostsResponse(TaskResult {
                        try await getPostsClient.send(sessionId: sessionId)
                    }))
                }
                
            case let .postDetail(.presented(.delegate(.block(postAnnotation)))):
                state.isShownPostDetailSheet = false
                state.postDetail = nil
                
                guard let sessionId = userDefaults.sessionId else {
                    print("check: No Session ID ")
                    return .none
                }
                
                return .run { send in
                    await send(.getPostsResponse(TaskResult {
                        try await getPostsClient.send(sessionId: sessionId)
                    }))
                }
                
            case .postDetail(.presented(.delegate(.dismiss))):
                state.isShownPostDetailSheet = false
                state.postDetail = nil
                return .none
                
            case .postDetail:
                return .none
            case .postDetailSheetDismiss:
                state.isShownPostDetailSheet = false
                return .none
                
            case .myPage(.presented(.delegate(.showEditProfile))):
                state.destination = .editProfile(EditProfile.State())
                state.myPage = nil
                return .none
                
            case .myPage:
                return .none
                
            case .myPageSheetDismiss:
                state.myPage = nil
                return .none
                
            case let .centerRegionChanged(region):
                state.centerRegion = region
                return .none
            case .cancelButtonTappedInSelectPlaceMode:
                if state.isSelectPlaceMode == true {
                    state.isSelectPlaceMode = false
                }
                return .none
            case .confirmButtonTappedInSelectPlaceMode:
                guard let center = state.centerRegion else {
                    return .none
                }
                
                state.destination = .post(PostStore.State(center: center))
                state.isSelectPlaceMode = false
                return .none
                
            case .destination(_):
                return .none
                
            case .binding:
                return .none
                
            case .alert(.presented(.failToGetPosts)):
                return .run { send in
                    await send(.task)
                }
                
            case .alert:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
        .ifLet(\.$destination, action: \.destination)
        .ifLet(\.$postDetail, action: \.postDetail) {
            PostDetail()
        }
        .ifLet(\.$myPage, action: \.myPage) {
            MyPage()
        }
        
        BindingReducer()
    }
}

extension MapStore {
    @Reducer(state: .equatable)
    public enum Path {
        case post(PostStore)
        case editProfile(EditProfile)
    }
}

extension GetPostEntity {
    func convert() -> PostAnnotation {
        return .init(
            postId: self.postId,
            postUserId: self.postUserId,
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
