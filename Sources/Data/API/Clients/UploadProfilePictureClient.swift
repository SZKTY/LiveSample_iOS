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
public struct UploadProfilePictureClient: Sendable {
    public var upload: @Sendable (_ sessionId: String, _ data: Data) async throws -> UploadProfilePictureResponse
}

extension UploadProfilePictureClient: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue = Self()
}

public extension DependencyValues {
    var uploadProfilePictureClient: UploadProfilePictureClient {
        get { self[UploadProfilePictureClient.self] }
        set { self[UploadProfilePictureClient.self] = newValue }
    }
}

extension UploadProfilePictureClient: DependencyKey {
    public static var liveValue: UploadProfilePictureClient = .request()
    
    static func request() -> Self {
        .init(
            upload: { sessionId, data in
                try await APIClient.upload(
                    UploadProfilePictureRequest(data: data),
                    with: sessionId
                )
            }
        )
    }
}

