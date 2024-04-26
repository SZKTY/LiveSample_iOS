//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/24.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct PostStore {
    public struct State: Equatable {
        @PresentationState public var alert: AlertState<Action.Alert>?
        
        @BindingState public var image: Data = Data()
        @BindingState public var freeText: String = ""
        @BindingState public var coordinateX: String = ""
        @BindingState public var coordinateY: String = ""
        @BindingState public var startDate: Date = Date()
        @BindingState public var endDate: Date = Date()
        
        @BindingState public var isEnableCreatePostButton: Bool = false
        public init() {}
    }
    
    public enum Action: BindableAction {
        case createPostButtonTapped
//        case postResponse(Result<IssueAccountResponse, Error>)
        case alert(PresentationAction<Alert>)
        case binding(BindingAction<State>)
        
        public enum Alert: Equatable {
            case failToCreatePost
        }
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .createPostButtonTapped:
                return .none
            case .alert:
                return .none
            case .binding:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
        
        BindingReducer()
    }
}

