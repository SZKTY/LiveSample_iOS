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
public struct VerifyMailAdressClient: Sendable {
    public var send: @Sendable (_ email: String) async throws -> VerifyMailAdressResponse
}

extension VerifyMailAdressClient: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue = Self()
}

public extension DependencyValues {
    var verifyMailAdressClient: VerifyMailAdressClient {
        get { self[VerifyMailAdressClient.self] }
        set { self[VerifyMailAdressClient.self] = newValue }
    }
}

extension VerifyMailAdressClient: DependencyKey {
    public static var liveValue: VerifyMailAdressClient = .request()
    
    static func request() -> Self {
        .init(
            send: { email in
                try await APIClient.send(
                    VerifyMailAdressRequest(email: email),
                    with: ""
                )
            }
        )
    }
}

