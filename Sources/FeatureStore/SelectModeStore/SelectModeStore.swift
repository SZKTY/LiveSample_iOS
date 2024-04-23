//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/01.
//

import ComposableArchitecture
import User
import API

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
        case registerAccountTypeResponse(Result<RegisterAccountTypeResponse, Error>)
    }
    
    public init() {}
    
    // MARK: - Dependencies
    @Dependency(\.registerAccountTypeClient) var registerAccountTypeClient
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .didTapFan:
                return .run { send in
                    await send(.registerAccountTypeResponse(Result {
                        try await registerAccountTypeClient.send(isMusician: false)
                    }))
                }
                
            case .didTapMusician:
                state.userRegist.isMusician = true
                return .run { send in
                    await send(.registerAccountTypeResponse(Result {
                        try await registerAccountTypeClient.send(isMusician: true)
                    }))
                }
                
            case let .registerAccountTypeResponse(.success(response)):
                return .none
                
            case let .registerAccountTypeResponse(.failure(error)):
                return .none
            }
        }
    }
}
