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
public struct EditUserProfileImageClient: Sendable {
    public var send: @Sendable (_ sessionId: String, _ path: String) async throws -> EditUserProfileImageResponse
}

extension EditUserProfileImageClient: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue = Self()
}

public extension DependencyValues {
    var editUserProfileImageClient: EditUserProfileImageClient {
        get { self[EditUserProfileImageClient.self] }
        set { self[EditUserProfileImageClient.self] = newValue }
    }
}

extension EditUserProfileImageClient: DependencyKey {
    public static var liveValue: EditUserProfileImageClient = .request()
    
    static func request() -> Self {
        .init(
            send: { sessionId, path in
                try await APIClient.send(
                    EditUserProfileImageRequest(path: path),
                    with: sessionId
                )
            }
        )
    }
}


