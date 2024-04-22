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
public struct AccountInfoRegistDependency: Sendable {
    public var send: @Sendable (_ accountId: String, _ accountName: String) async throws -> Decodable
}

extension AccountInfoRegistDependency: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue = Self()
}

public extension DependencyValues {
    var accountInfoRegistDependency: AccountInfoRegistDependency {
        get { self[AccountInfoRegistDependency.self] }
        set { self[AccountInfoRegistDependency.self] = newValue }
    }
}

extension AccountInfoRegistDependency: DependencyKey {
    public static var liveValue: AccountInfoRegistDependency = .request()
    
    static func request() -> Self {
        .init(
            send: { accountId, accountName in
                try await APIClient.send(
                    AccountInfoRegistRequest(accountId: accountId, accountName: accountName),
                    withAuth: true
                )
            }
        )
    }
}

