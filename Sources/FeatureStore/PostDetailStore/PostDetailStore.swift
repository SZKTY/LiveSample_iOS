//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/06/13.
//

import ComposableArchitecture
import MapKit
import PostAnnotation

@Reducer
public struct PostDetail {
    public struct State: Equatable {
        public let annotation: PostAnnotation
        
        public init(annotation: PostAnnotation) {
            self.annotation = annotation
        }
    }
    
    public enum Action: BindableAction {
        case initialize
        case delegate(Delegate)
        case binding(BindingAction<State>)
        
        public enum Delegate: Equatable {
            case move
        }
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .initialize:
                return .send(.delegate(.move))
                
            case .delegate:
                return .none
                
            case .binding:
                return .none
            }
        }
    }
}
