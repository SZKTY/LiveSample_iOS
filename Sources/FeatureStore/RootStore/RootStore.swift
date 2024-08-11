//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/08.
//

import Foundation
import ComposableArchitecture
import API
import UserDefaults
import Config

@Reducer
public struct Root {
    public struct State: Equatable {
        @PresentationState public var alert: AlertState<Action.Alert>?
        public var isInitialized: Bool = false
        public var requiredInfo: GetRequiredInfoResponse = .stub()
        
        public init() {}
    }
    
    public enum Action {
        case initialize
        case beInitialized
        case task
        case getRequiredInfoResponse(Result<GetRequiredInfoResponse, Error>)
        case listenRemoteConfigResponse(TaskResult<Config?>)
        case alert(PresentationAction<Alert>)
        
        public enum Alert: Equatable {
            case Task
            case RequiredInfo
            case Maintanance(Config)
            case ForceUpdate(Config)
        }
    }
    
    // MARK: - Dependencies
    @Dependency(\.remoteConfigClient) var remoteConfigClient
    @Dependency(\.userDefaults) var userDefaults
    @Dependency(\.getRequiredInfoClient) var getRequiredInfoClient
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .initialize:
                // SessionID / UserID がローカルに存在しない場合は、以降の処理を止めて初期化完了とする
                guard let sessionId = userDefaults.sessionId,
                      userDefaults.userId != nil else {
                    print("check: No Session ID")
                    
                    return .run { send in
                        await send(.beInitialized)
                    }
                }
                
                return .run { send in
                    await send(.getRequiredInfoResponse( Result {
                        try await getRequiredInfoClient.send(sessionId: sessionId)
                    }))
                }
                
            case let .getRequiredInfoResponse(.success(response)):
                print("check: getRequiredInfoResponse success")
                state.requiredInfo = response
                
                // 必須情報が足りなければ、ログアウト状態に戻す
                if response.accountId.isEmpty || response.accountName.isEmpty || response.accountType.isEmpty {
                    NotificationCenter.default.post(name: NSNotification.changeToLogout, object: nil, userInfo: nil)
                }
                
                return .run { send in
                    await send(.beInitialized)
                }
                
            case let .getRequiredInfoResponse(.failure(error)):
                print("check: getRequiredInfoResponse failure")
                
                state.alert = .init(
                    title: .init(error.asApiError?.message ?? error.localizedDescription),
                    buttons: [
                        .default(.init("リトライ"), action: .send(.RequiredInfo))
                    ]
                )
                return .none
                
            case .beInitialized:
                state.isInitialized = true
                return .none
                
            case .task:
                return .run { send in
                    for try await result in try await self.remoteConfigClient.listenRemoteConfig() {
                        await send(.listenRemoteConfigResponse(.success(result)))
                    }
                } catch: { error, send in
                    await send(.listenRemoteConfigResponse(.failure(error)))
                }
                
            case let .listenRemoteConfigResponse(.success(config)):
                guard let config else { return .none }
                
                if config.isInMaintenance {
                    state.alert = .init(
                        title: .init("メンテナンス中です"),
                        message: .init(config.maintenanceMessage ?? ""),
                        buttons: [
                            .default(.init("OK"), action: .send(.Maintanance(config)))
                        ]
                    )
                    return .none
                } else if config.isInForceUpdate {
                    state.alert = .init(
                        title: .init("アップデートが必要です"),
                        message: .init(config.forceUpdateMessage ?? ""),
                        buttons: [
                            .default(.init("OK"), action: .send(.ForceUpdate(config)))
                        ]
                    )
                    return .none
                }
                
                return .run { send in
                    await send(.initialize)
                }
                
            case let .listenRemoteConfigResponse(.failure(error)):
                state.alert = .init(
                    title: .init(error.asApiError?.message ?? error.localizedDescription),
                    buttons: [
                        .default(.init("リトライ"), action: .send(.Task))
                    ]
                )
                return .none
                
            case .alert(.presented(.Task)):
                return .run { send in
                    await send(.task)
                }
                
            case .alert(.presented(.RequiredInfo)):
                return .run { send in
                    await send(.initialize)
                }
                
            case let .alert(.presented(.Maintanance(config))):
                if config.isInMaintenance {
                    state.alert = .init(
                        title: .init("メンテナンス中です"),
                        message: .init(config.maintenanceMessage ?? ""),
                        buttons: [
                            .default(.init("OK"), action: .send(.Maintanance(config)))
                        ]
                    )
                    return .none
                } else if config.isInForceUpdate {
                    state.alert = .init(
                        title: .init("アップデートが必要です"),
                        message: .init(config.forceUpdateMessage ?? ""),
                        buttons: [
                            .default(.init("OK"), action: .send(.ForceUpdate(config)))
                        ]
                    )
                    return .none
                }
                
                return .run { send in
                    await send(.initialize)
                }
                
            case let .alert(.presented(.ForceUpdate(config))):
                if let url = config.storeUrl {
                    config.openURL(to: url)
                }
                
                if config.isInMaintenance {
                    state.alert = .init(
                        title: .init("メンテナンス中です"),
                        message: .init(config.maintenanceMessage ?? ""),
                        buttons: [
                            .default(.init("OK"), action: .send(.Maintanance(config)))
                        ]
                    )
                    return .none
                } else if config.isInForceUpdate {
                    state.alert = .init(
                        title: .init("アップデートが必要です"),
                        message: .init(config.forceUpdateMessage ?? ""),
                        buttons: [
                            .default(.init("OK"), action: .send(.ForceUpdate(config)))
                        ]
                    )
                    return .none
                }
                
                return .run { send in
                    await send(.initialize)
                }
                
            case .alert:
                return .none
            }
        }.ifLet(\.$alert, action: \.alert)
    }
}


extension NSNotification {
    public static let changeToLogout = Notification.Name.init("changeToLogout")
}
