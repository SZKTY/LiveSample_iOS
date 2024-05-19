//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/05/19.
//

import Foundation
import Dependencies
import DependenciesMacros

@DependencyClient
public struct LoginClient: Sendable {
    public var send: @Sendable (_ email: String, _ password: String) async throws -> LoginResponse
}

extension LoginClient: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue = Self()
}

public extension DependencyValues {
    var loginClient: LoginClient {
        get { self[LoginClient.self] }
        set { self[LoginClient.self] = newValue }
    }
}

extension LoginClient: DependencyKey {
    public static var liveValue: LoginClient = .request()
    
    static func request() -> Self {
        .init(
            send: { email, password in
                try await APIClient.send(
                    LoginRequest(email: email, password: password),
                    with: ""
                )
            }
        )
    }
}

