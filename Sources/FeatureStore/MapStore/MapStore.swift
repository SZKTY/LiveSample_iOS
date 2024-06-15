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

@Reducer
public struct MapStore {
    public struct State: Equatable {
        @PresentationState public var destination: Path.State?
        @PresentationState public var postDetail: PostDetail.State?
        @BindingState public var isSelectPlaceMode: Bool = false
        @BindingState public var isShownPostDetailSheet: Bool = false
        @BindingState public var postAnnotations: [PostAnnotation] = []
        
        public var centerRegion: CLLocationCoordinate2D?
        public init() {}
    }
    
    public enum Action: BindableAction {
        case floatingPlusButtonTapped
        case floatingHomeButtonTapped
        case annotationTapped(annotation: PostAnnotation)
        case postDetail(PresentationAction<PostDetail.Action>)
        case postDetailSheetDismiss
        case centerRegionChanged(region: CLLocationCoordinate2D)
        case cancelButtonTappedInSelectPlaceMode
        case confirmButtonTappedInSelectPlaceMode
        case destination(PresentationAction<Path.Action>)
        case binding(BindingAction<State>)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
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
