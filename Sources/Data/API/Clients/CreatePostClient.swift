//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/05/18.
//

import Foundation
import Dependencies
import DependenciesMacros
import PostEntity

@DependencyClient
public struct CreatePostClient: Sendable {
    public var send: @Sendable (_ sessionId: String, _ entity: PostEntity) async throws -> CreatePostResponse
}

extension CreatePostClient: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue = Self()
}

public extension DependencyValues {
    var createPostClient: CreatePostClient {
        get { self[CreatePostClient.self] }
        set { self[CreatePostClient.self] = newValue }
    }
}

extension CreatePostClient: DependencyKey {
    public static var liveValue: CreatePostClient = .request()
    
    static func request() -> Self {
        .init(
            send: { sessionId, entity in
                try await APIClient.send(
                    CreatePostRequest(param: entity),
                    with: sessionId
                )
            }
        )
    }
}

