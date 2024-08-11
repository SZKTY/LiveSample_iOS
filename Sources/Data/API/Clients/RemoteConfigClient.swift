//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/05/03.
//

import Foundation
import FirebaseRemoteConfig
import Dependencies
import DependenciesMacros
import Config

public struct RemoteConfigClient: Sendable {
    public var listenRemoteConfig: @Sendable () async throws -> AsyncThrowingStream<Config?, Error>

    public init(
        listenAuthState: @escaping @Sendable () async throws -> AsyncThrowingStream<Config?, Error>
    ) {
        self.listenRemoteConfig = listenAuthState
    }
}

extension DependencyValues {
    public var remoteConfigClient: RemoteConfigClient {
        get { self[RemoteConfigClient.self] }
        set { self[RemoteConfigClient.self] = newValue }
    }
}

extension RemoteConfigClient: DependencyKey {
    private static let remoteConfig: RemoteConfig = RemoteConfig.remoteConfig()

    public static let liveValue = Self(
        listenAuthState: {
            AsyncThrowingStream { continuation in
                Self.remoteConfig.fetchAndActivate { status, error in
                    switch status {
                    case .successUsingPreFetchedData, .successFetchedFromRemote:
                        print("check: success fetchAndActivate")
                        let config = Self.makeConfig()
                        continuation.yield(config)
                    default:
                        if let error {
                            print(error.localizedDescription)
                            continuation.yield(nil)
                        }
                    }
                }

                // Updateを監視する
                Self.remoteConfig.addOnConfigUpdateListener { configUpdate, error in
                    if let error {
                        print(error.localizedDescription)
                        continuation.yield(nil)
                    }
                    // Fetchしてきたデータを有効化する
                    remoteConfig.activate()
                    
                    print("check: success addOnConfigUpdateListener")
                    let config = Self.makeConfig()
                    continuation.yield(config)
                }
            }
        }
    )
    
    private static func makeConfig() -> Config {
        var config = Config()
        // 強制アップデート
        config.forceUpdateRequiredVersion = Self.remoteConfig.configValue(forKey: "forceUpdate_requiredVersion").stringValue
        config.forceUpdateStartDate = Self.remoteConfig.configValue(forKey: "forceUpdate_startDate").stringValue
        config.forceUpdateEndDate = Self.remoteConfig.configValue(forKey: "forceUpdate_endDate").stringValue
        config.forceUpdateMessage = Self.remoteConfig.configValue(forKey: "forceUpdate_message").stringValue
        
        // メンテナンス
        config.maintenanceStartDate = Self.remoteConfig.configValue(forKey: "maintenance_startDate").stringValue
        config.maintenanceEndDate = Self.remoteConfig.configValue(forKey: "maintenance_endDate").stringValue
        config.maintenanceMessage = Self.remoteConfig.configValue(forKey: "maintenance_message").stringValue
        
        // ストアURL
        config.storeUrl = Self.remoteConfig.configValue(forKey: "store_url").stringValue
        
        return config
    }
}
