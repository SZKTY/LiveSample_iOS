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
    func addAuthInfo<T: APIRequest>(to request: T, token: String) -> T
}

public final class APIClient: Sendable {
    public static var authenticateStrategy: AuthenticateStrategy = ParameterAuthenticationStrategy()

    public static func send<T: APIRequest>(_ origin: T, with sessionId: String? = nil) async throws -> T.Response {
        let request: T
        if let sessionId = sessionId {
            request = authenticateStrategy.addAuthInfo(to: origin, token: sessionId)
        } else {
            request = origin
        }
        return try await self.requestData(request)
    }
    
    public static func upload<T: APIRequest>(_ origin: T, with sessionId: String? = nil) async throws -> T.Response {
        let request: T
        if let sessionId = sessionId {
            request = authenticateStrategy.addAuthInfo(to: origin, token: sessionId)
        } else {
            request = origin
        }
        return try await self.uploadData(request)
    }
}

extension APIClient {
    private static func requestData<T: APIRequest>(_ origin: T) async throws -> T.Response {

#if DEBUG
        print("check: baseURL: \(origin.baseURL)")
        print("check: request path: \(origin.path)")
        print("check: url: \(origin.url)")
        print("check: method: \(origin.method)")
        print("check: headers: \(origin.headers ?? [])")
        print("check: parameters: \(origin.parameters ?? [:])")
        print("check: timeout: \(origin.timeout)")
#endif

        URLCache.shared.removeAllCachedResponses()
        
        let dataRequest = AF.request(origin.url,
                                     method: origin.method,
                                     parameters: origin.parameters,
                                     encoding: JSONEncoding.default,
                                     headers: origin.headers,
                                     requestModifier: { $0.timeoutInterval = origin.timeout })
        
        return try await dataRequest.publish(T.Response.self)
    }
    
    private static func uploadData<T: APIRequest>(_ origin: T) async throws -> T.Response {

#if DEBUG
        print("check: baseURL: \(origin.baseURL)")
        print("check: request path: \(origin.path)")
        print("check: url: \(origin.url)")
        print("check: method: \(origin.method)")
        print("check: headers: \(origin.headers ?? [])")
        print("check: parameters: \(origin.parameters ?? [:])")
        print("check: timeout: \(origin.timeout)")
#endif

        URLCache.shared.removeAllCachedResponses()
        
        let dataUpload = AF.upload(multipartFormData: { data in
            data.append(origin.parameters!["image"] as! Data,
                        withName: "image",
                        fileName: "image.jpeg",
                        mimeType: "image/jpeg")
        }, to: origin.url, method: origin.method, headers: origin.headers)
        
        return try await dataUpload.publish(T.Response.self)
    }
}

extension DataRequest {
    func publish<T>(_ type: T.Type) async throws -> T where T : Decodable {
        try await withCheckedThrowingContinuation { continuation in
            self.response { response in
                switch response.result {
                case .success(let element): do {
                    print("check: data = \(element?.base64EncodedString())")
                    
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let decodedResponse = try jsonDecoder.decode(type, from: element!)
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
