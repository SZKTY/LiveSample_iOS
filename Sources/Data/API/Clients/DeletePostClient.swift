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
public struct DeletePostClient: Sendable {
    public var send: @Sendable (_ sessionId: String, _ deletePostId: Int) async throws -> DeletePostResponse
}

extension DeletePostClient: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue = Self()
}

public extension DependencyValues {
    var deletePostClient: DeletePostClient {
        get { self[DeletePostClient.self] }
        set { self[DeletePostClient.self] = newValue }
    }
}

extension DeletePostClient: DependencyKey {
    public static var liveValue: DeletePostClient = .request()
    
    static func request() -> Self {
        .init(
            send: { sessionId, deletePostId in
                try await APIClient.send(
                    DeletePostRequest(deletePostId: deletePostId),
                    with: sessionId
                )
            }
        )
    }
}
