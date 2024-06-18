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
public struct GetRequiredInfoClient: Sendable {
    public var send: @Sendable (_ sessionId: String) async throws -> GetRequiredInfoResponse
}

extension GetRequiredInfoClient: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue = Self()
}

public extension DependencyValues {
    var getRequiredInfoClient: GetRequiredInfoClient {
        get { self[GetRequiredInfoClient.self] }
        set { self[GetRequiredInfoClient.self] = newValue }
    }
}

extension GetRequiredInfoClient: DependencyKey {
    public static var liveValue: GetRequiredInfoClient = .request()
    
    static func request() -> Self {
        .init(
            send: { sessionId in
                try await APIClient.send(
                    GetRequiredInfoRequest(),
                    with: sessionId
                )
            }
        )
    }
}

