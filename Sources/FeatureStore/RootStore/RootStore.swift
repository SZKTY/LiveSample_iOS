//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/08.
//

import Foundation
import ComposableArchitecture
import API
import Config

@Reducer
public struct Root {
    public struct State: Equatable {
        @PresentationState public var alert: AlertState<Action.Alert>?
        
        public init() {}
    }
    
    public enum Action {
        case task
        case listenRemoteConfigResponse(TaskResult<Config?>)
        case alert(PresentationAction<Alert>)
        
        public enum Alert: Equatable {
            case Maintanance
            case ForceUpdate
        }
    }
    
    public init() {}
    
    // MARK: - Dependencies
    @Dependency(\.remoteConfigClient) var remoteConfigClient
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .task:
                return .run { send in
                    for try await result in try await self.remoteConfigClient.listenRemoteConfig() {
                        await send(.listenRemoteConfigResponse(.success(result)))
                    }
                } catch: { error, send in
                    await send(.listenRemoteConfigResponse(.failure(error)))
                }
                
            case let .listenRemoteConfigResponse(.success(config)):
                if let config = config {
                    state.alert = AlertState(title: TextState("\(config.requiredVersion ?? 0)"))
                }
                return .none
                
            case let .listenRemoteConfigResponse(.failure(error)):
                return .none
                
            case .alert(.presented(.Maintanance)):
                return .none
                
            case .alert(.presented(.ForceUpdate)):
                return .none
                
            case .alert:
                return .none
            }
        }.ifLet(\.$alert, action: \.alert)
    }
}


