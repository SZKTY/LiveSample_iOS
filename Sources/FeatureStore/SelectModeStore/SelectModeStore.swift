//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/01.
//

import ComposableArchitecture
import User

@Reducer
public struct SelectMode {
    public struct State: Equatable {
        public var userRegist: UserRegist
        
        public init(userRegist: UserRegist) {
            self.userRegist = userRegist
        }
    }
    
    public enum Action {
        case didTapFan
        case didTapMusician
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .didTapFan:
                state.userRegist.isMusician = false
                return .none
                
            case .didTapMusician:
                state.userRegist.isMusician = true
                return .none
            }
        }
    }
}
