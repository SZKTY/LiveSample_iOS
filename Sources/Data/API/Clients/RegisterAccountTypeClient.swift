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
    public var send: @Sendable (_ isMusician: Bool) async throws -> RegisterAccountTypeResponse
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
            send: { isMusician in
                try await APIClient.send(
                    RegisterAccountTypeRequest(isMusician: isMusician),
                    withAuth: false
                )
            }
        )
    }
}

