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
public struct RegisterProfilePictureClient: Sendable {
    public var send: @Sendable (_ data: Data) async throws -> RegisterProfilePictureResponse
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
            send: { data in
                try await APIClient.send(
                    RegisterProfilePictureRequest(data: data),
                    withAuth: false
                )
            }
        )
    }
}

