//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/11/24.
//

import Foundation
import Dependencies
import DependenciesMacros

@DependencyClient
public struct ResetPasswordClient: Sendable {
    public var send: @Sendable (_ passwordResetToken: String, _ password: String) async throws -> ResetPasswordResponse
}

extension ResetPasswordClient: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue = Self()
}

public extension DependencyValues {
    var resetPasswordClient: ResetPasswordClient {
        get { self[ResetPasswordClient.self] }
        set { self[ResetPasswordClient.self] = newValue }
    }
}

extension ResetPasswordClient: DependencyKey {
    public static var liveValue: ResetPasswordClient = .request()
    
    static func request() -> Self {
        .init(
            send: { passwordResetToken, password in
                try await APIClient.send(
                    ResetPasswordRequest(passwordResetToken: passwordResetToken, password: password),
                    with: ""
                )
            }
        )
    }
}

