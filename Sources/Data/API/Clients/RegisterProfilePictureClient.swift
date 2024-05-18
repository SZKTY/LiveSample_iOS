//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/05/13.
//

import Foundation
import Dependencies
import DependenciesMacros

@DependencyClient
public struct RegisterProfilePictureClient: Sendable {
    public var send: @Sendable (_ sessionId: String, _ path: String) async throws -> RegisterProfilePictureResponse
}

extension RegisterProfilePictureClient: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue = Self()
}

public extension DependencyValues {
    var registerProfilePictureClient: RegisterProfilePictureClient {
        get { self[RegisterProfilePictureClient.self] }
        set { self[RegisterProfilePictureClient.self] = newValue }
    }
}

extension RegisterProfilePictureClient: DependencyKey {
    public static var liveValue: RegisterProfilePictureClient = .request()
    
    static func request() -> Self {
        .init(
            send: { sessionId, path in
                try await APIClient.send(
                    RegisterProfilePictureRequest(path: path),
                    with: sessionId
                )
            }
        )
    }
}


