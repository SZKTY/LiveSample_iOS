//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/05/26.
//

import Foundation
import Dependencies
import DependenciesMacros
import PostEntity

@DependencyClient
public struct GetPostsClient: Sendable {
    public var send: @Sendable (_ sessionId: String) async throws -> GetPostsResponse
}

extension GetPostsClient: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue = Self()
}

public extension DependencyValues {
    var getPostsClient: GetPostsClient {
        get { self[GetPostsClient.self] }
        set { self[GetPostsClient.self] = newValue }
    }
}

extension GetPostsClient: DependencyKey {
    public static var liveValue: GetPostsClient = .request()
    
    static func request() -> Self {
        .init(
            send: { sessionId in
                try await APIClient.send(
                    GetPostsRequest(),
                    with: sessionId
                )
            }
        )
    }
}

