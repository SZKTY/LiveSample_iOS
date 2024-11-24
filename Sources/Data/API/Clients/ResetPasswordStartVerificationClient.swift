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
public struct ResetPasswordStartVerificationClient: Sendable {
    public var send: @Sendable (_ email: String) async throws -> ResetPasswordStartVerificationResponse
}

extension ResetPasswordStartVerificationClient: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue = Self()
}

public extension DependencyValues {
    var resetPasswordStartVerificationClient: ResetPasswordStartVerificationClient {
        get { self[ResetPasswordStartVerificationClient.self] }
        set { self[ResetPasswordStartVerificationClient.self] = newValue }
    }
}

extension ResetPasswordStartVerificationClient: DependencyKey {
    public static var liveValue: ResetPasswordStartVerificationClient = .request()
    
    static func request() -> Self {
        .init(
            send: { email in
                try await APIClient.send(
                    ResetPasswordStartVerificationRequest(email: email),
                    with: ""
                )
            }
        )
    }
}

