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
public struct IssueAccountClient: Sendable {
    public var send: @Sendable (_ email: String, _ password: String) async throws -> IssueAccountResponse
}

extension IssueAccountClient: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue = Self()
}

public extension DependencyValues {
    var issueAccountClient: IssueAccountClient {
        get { self[IssueAccountClient.self] }
        set { self[IssueAccountClient.self] = newValue }
    }
}

extension IssueAccountClient: DependencyKey {
    public static var liveValue: IssueAccountClient = .request()
    
    static func request() -> Self {
        .init(
            send: { email, password in
                try await APIClient.send(
                    IssueAccountRequest(email: email, password: password),
                    with: ""
                )
            }
        )
    }
}

