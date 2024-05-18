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
public struct UploadPictureClient: Sendable {
    public var upload: @Sendable (_ sessionId: String, _ data: Data) async throws -> UploadPictureResponse
}

extension UploadPictureClient: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue = Self()
}

public extension DependencyValues {
    var uploadPictureClient: UploadPictureClient {
        get { self[UploadPictureClient.self] }
        set { self[UploadPictureClient.self] = newValue }
    }
}

extension UploadPictureClient: DependencyKey {
    public static var liveValue: UploadPictureClient = .request()
    
    static func request() -> Self {
        .init(
            upload: { sessionId, data in
                try await APIClient.upload(
                    UploadPictureRequest(data: data),
                    with: sessionId
                )
            }
        )
    }
}

