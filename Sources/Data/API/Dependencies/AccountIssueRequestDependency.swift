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
public struct AccountIssueRequestDependency: Sendable {
    public var send: @Sendable (_ email: String) async throws -> Decodable
}

extension AccountIssueRequestDependency: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue = Self()
}

public extension DependencyValues {
    var accountIssueRequestDependency: AccountIssueRequestDependency {
        get { self[AccountIssueRequestDependency.self] }
        set { self[AccountIssueRequestDependency.self] = newValue }
    }
}

extension AccountIssueRequestDependency: DependencyKey {
    public static var liveValue: AccountIssueRequestDependency = .request()
    
    static func request() -> Self {
        .init(
            send: { email in
                try await APIClient.send(
                    AccountIssueRequest(email: email),
                    withAuth: true
                )
            }
        )
    }
}

