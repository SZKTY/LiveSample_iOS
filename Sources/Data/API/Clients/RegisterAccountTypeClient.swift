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
public struct RegisterAccountTypeClient: Sendable {
    public var send: @Sendable (_ sessionId: String, _ accountType: String) async throws -> RegisterAccountTypeResponse
}

extension RegisterAccountTypeClient: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue = Self()
}

public extension DependencyValues {
    var registerAccountTypeClient: RegisterAccountTypeClient {
        get { self[RegisterAccountTypeClient.self] }
        set { self[RegisterAccountTypeClient.self] = newValue }
    }
}

extension RegisterAccountTypeClient: DependencyKey {
    public static var liveValue: RegisterAccountTypeClient = .request()
    
    static func request() -> Self {
        .init(
            send: { sessionId, accountType in
                try await APIClient.send(
                    RegisterAccountTypeRequest(accountType: accountType),
                    with: sessionId
                )
            }
        )
    }
}

