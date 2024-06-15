//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/05/06.
//

import ComposableArchitecture
import CoreLocation

@Reducer
public struct MapWithCrossStore {
    public struct State: Equatable {
        @BindingState public var center: CLLocationCoordinate2D
        
        public init(center: CLLocationCoordinate2D) {
            self.center = center
        }
    }
    
    public enum Action: BindableAction {
        case centerRegionChanged(location: CLLocationCoordinate2D)
        case cancelButtonTapped
        case determineButtonTapped
        case delegate(Delegate)
        case binding(BindingAction<State>)
        
        public enum Delegate: Equatable {
            case saveCenter(CLLocationCoordinate2D)
        }
    }
    
    public init() {}
    
    @Dependency(\.dismiss) var dismiss
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .centerRegionChanged(region):
                state.center = region
                return .none
            case .cancelButtonTapped:
                return .run { _ in await self.dismiss() }
            case .determineButtonTapped:
                return .run { [center = state.center] send in
                    NotificationCenter.default.post(name: NSNotification.didDetermineCenter, object: nil, userInfo: ["center": center])
                    await self.dismiss()
                }
            case .delegate:
                return .none
            case .binding:
                return .none
            }
        }
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

extension NSNotification {
    public static let didDetermineCenter = Notification.Name.init("didDetermineCenter")
    public static let didSuccessCreatePost = Notification.Name.init("didSuccessCreatePost")
}
