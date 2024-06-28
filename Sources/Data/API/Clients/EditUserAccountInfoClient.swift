//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/06/28.
//

import Foundation
import Dependencies
import DependenciesMacros

@DependencyClient
public struct EditUserAccountInfoClient: Sendable {
    public var send: @Sendable (_ sessionId: String, _ accountId: String, _ accountName: String) async throws -> EditUserAccountInfoResponse
}

extension EditUserAccountInfoClient: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue = Self()
}

public extension DependencyValues {
    var editUserAccountInfoClient: EditUserAccountInfoClient {
        get { self[EditUserAccountInfoClient.self] }
        set { self[EditUserAccountInfoClient.self] = newValue }
    }
}

extension EditUserAccountInfoClient: DependencyKey {
    public static var liveValue: EditUserAccountInfoClient = .request()
    
    static func request() -> Self {
        .init(
            send: { sessionId, accountId, accountName in
                try await APIClient.send(
                    EditUserAccountInfoRequest(accountId: accountId, accountName: accountName),
                    with: sessionId
                )
            }
        )
    }
}

