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
public struct ProfilePictureRegistDependency: Sendable {
    public var send: @Sendable (_ data: Data) async throws -> Decodable
}

extension ProfilePictureRegistDependency: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue = Self()
}

public extension DependencyValues {
    var profilePictureRegistDependency: ProfilePictureRegistDependency {
        get { self[ProfilePictureRegistDependency.self] }
        set { self[ProfilePictureRegistDependency.self] = newValue }
    }
}

extension ProfilePictureRegistDependency: DependencyKey {
    public static var liveValue: ProfilePictureRegistDependency = .request()
    
    static func request() -> Self {
        .init(
            send: { data in
                try await APIClient.send(
                    ProfilePictureRegistRequest(data: data),
                    withAuth: true
                )
            }
        )
    }
}

