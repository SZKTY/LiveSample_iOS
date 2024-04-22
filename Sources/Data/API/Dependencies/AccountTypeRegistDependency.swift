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
public struct AccountTypeRegistDependency: Sendable {
    public var send: @Sendable (_ isMusician: Bool) async throws -> Decodable
}

extension AccountTypeRegistDependency: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue = Self()
}

public extension DependencyValues {
    var accountTypeRegistDependency: AccountTypeRegistDependency {
        get { self[AccountTypeRegistDependency.self] }
        set { self[AccountTypeRegistDependency.self] = newValue }
    }
}

extension AccountTypeRegistDependency: DependencyKey {
    public static var liveValue: AccountTypeRegistDependency = .request()
    
    static func request() -> Self {
        .init(
            send: { isMusician in
                try await APIClient.send(
                    AccountTypeRegistRequest(isMusician: isMusician),
                    withAuth: true
                )
            }
        )
    }
}

