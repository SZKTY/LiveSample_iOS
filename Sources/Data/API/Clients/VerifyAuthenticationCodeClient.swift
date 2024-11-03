//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/11/03.
//

import Foundation
import Dependencies
import DependenciesMacros

@DependencyClient
public struct VerifyAuthenticationCodeClient: Sendable {
    public var send: @Sendable (_ code: String) async throws -> VerifyAuthenticationCodeResponse
}

extension VerifyAuthenticationCodeClient: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue = Self()
}

public extension DependencyValues {
    var verifyauthenticationCodeClient: VerifyAuthenticationCodeClient {
        get { self[VerifyAuthenticationCodeClient.self] }
        set { self[VerifyAuthenticationCodeClient.self] = newValue }
    }
}

extension VerifyAuthenticationCodeClient: DependencyKey {
    public static var liveValue: VerifyAuthenticationCodeClient = .request()
    
    static func request() -> Self {
        .init(
            send: { code in
                try await APIClient.send(
                    VerifyAuthenticationCodeRequest(code: code),
                    with: ""
                )
            }
        )
    }
}

