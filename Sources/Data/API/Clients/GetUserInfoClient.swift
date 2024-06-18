//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/06/18.
//

import Foundation
import Dependencies
import DependenciesMacros

@DependencyClient
public struct GetUserInfoClient: Sendable {
    public var send: @Sendable (_ sessionId: String) async throws -> GetUserInfoResponse
}

extension GetUserInfoClient: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue = Self()
}

public extension DependencyValues {
    var getUserInfoClient: GetUserInfoClient {
        get { self[GetUserInfoClient.self] }
        set { self[GetUserInfoClient.self] = newValue }
    }
}

extension GetUserInfoClient: DependencyKey {
    public static var liveValue: GetUserInfoClient = .request()
    
    static func request() -> Self {
        .init(
            send: { sessionId in
                try await APIClient.send(
                    GetUserInfoRequest(),
                    with: sessionId
                )
            }
        )
    }
}

