//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/22.
//

import Foundation
import Alamofire
import Dependencies
import DependenciesMacros

public protocol AuthObjectType {
    func token() -> String?
}

public protocol AuthenticateStrategy {
    func addAuthInfo<T: APIRequest>(to request: T, token: String?) -> T
}

public final class APIClient: Sendable {
    public static var authObject: AuthObjectType?
    public static var authenticateStrategy: AuthenticateStrategy?

    public static func register(authObject: AuthObjectType? = nil, authenticateStrategy: AuthenticateStrategy? = nil) {
        self.authObject = authObject
        self.authenticateStrategy = authenticateStrategy
    }

    public static func send<T: APIRequest>(_ origin: T, withAuth: Bool = false) async throws -> T.Response {
        let request: T
        if withAuth {
            request = authenticateStrategy?.addAuthInfo(to: origin, token: authObject?.token()) ?? origin
        } else {
            request = origin
        }
        return try await self.requestData(request)
    }
}

extension APIClient {
    private static func requestData<T: APIRequest>(_ origin: T) async throws -> T.Response {

#if DEBUG
        print("baseURL: \(origin.baseURL)")
        print("request path: \(origin.path)")
        print("method: \(origin.method)")
        print("headers: \(origin.headers ?? [])")
        print("parameters: \(origin.parameters ?? [:])")
        print("timeout: \(origin.timeout)")
#endif

        URLCache.shared.removeAllCachedResponses()
        
        let dataRequest = AF.request(origin.url,
                                     method: origin.method,
                                     parameters: origin.parameters,
                                     requestModifier: { $0.timeoutInterval = origin.timeout })
        
        return try await dataRequest.publish(T.Response.self)
    }
}

extension DataRequest {
    func publish<T>(_ type: T.Type) async throws -> T where T : Decodable {
        try await withCheckedThrowingContinuation { continuation in
            self.response { response in
                switch response.result {
                case .success(let element): do {
                    let decodedResponse = try JSONDecoder().decode(type, from: element!)
                    continuation.resume(returning: decodedResponse)
                } catch {
                    continuation.resume(throwing: error)
                }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
