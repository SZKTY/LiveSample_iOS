//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/22.
//

import Foundation
import Dependencies
import DependenciesMacros

@DependencyClient
public struct RegisterAccountInfoClient: Sendable {
    public var send: @Sendable (_ accountId: String, _ accountName: String) async throws -> RegisterAccountInfoResponse
}

extension RegisterAccountInfoClient: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue = Self()
}

public extension DependencyValues {
    var registerAccountInfoClient: RegisterAccountInfoClient {
        get { self[RegisterAccountInfoClient.self] }
        set { self[RegisterAccountInfoClient.self] = newValue }
    }
}

extension RegisterAccountInfoClient: DependencyKey {
    public static var liveValue: RegisterAccountInfoClient = .request()
    
    static func request() -> Self {
        .init(
            send: { accountId, accountName in
                try await APIClient.send(
                    RegisterAccountInfoRequest(accountId: accountId, accountName: accountName),
                    withAuth: false
                )
            }
        )
    }
}

