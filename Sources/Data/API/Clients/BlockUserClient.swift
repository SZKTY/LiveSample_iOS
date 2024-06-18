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
public struct BlockUserClient: Sendable {
    public var send: @Sendable (_ sessionId: String, _ blockUserId: Int) async throws -> BlockUserResponse
}

extension BlockUserClient: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue = Self()
}

public extension DependencyValues {
    var blockUserClient: BlockUserClient {
        get { self[BlockUserClient.self] }
        set { self[BlockUserClient.self] = newValue }
    }
}

extension BlockUserClient: DependencyKey {
    public static var liveValue: BlockUserClient = .request()
    
    static func request() -> Self {
        .init(
            send: { sessionId, blockUserId in
                try await APIClient.send(
                    BlockUserRequest(blockUserId: blockUserId),
                    with: sessionId
                )
            }
        )
    }
}

