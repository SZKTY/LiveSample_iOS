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
public struct ResetPasswordExecuteVerificationClient: Sendable {
    public var send: @Sendable (_ email: String, _ code: String) async throws -> ResetPasswordExecuteVerificationResponse
}

extension ResetPasswordExecuteVerificationClient: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue = Self()
}

public extension DependencyValues {
    var resetPasswordExecuteVerificationClient: ResetPasswordExecuteVerificationClient {
        get { self[ResetPasswordExecuteVerificationClient.self] }
        set { self[ResetPasswordExecuteVerificationClient.self] = newValue }
    }
}

extension ResetPasswordExecuteVerificationClient: DependencyKey {
    public static var liveValue: ResetPasswordExecuteVerificationClient = .request()
    
    static func request() -> Self {
        .init(
            send: { email, code in
                try await APIClient.send(
                    ResetPasswordExecuteVerificationRequest(email: email, code: code),
                    with: ""
                )
            }
        )
    }
}

