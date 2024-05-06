//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/24.
//

import ComposableArchitecture
import PostStore
import CoreLocation

@Reducer
public struct MapStore {
    public struct State: Equatable {
        @PresentationState public var destination: Path.State?
        @BindingState public var isSelectPlaceMode: Bool = false
        public var centerRegion: CLLocationCoordinate2D?
        public init() {}
    }
    
    public enum Action: BindableAction {
        case floatingButtonTapped
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
                state.destination = .post(PostStore.State())
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

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
