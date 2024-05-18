//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/22.
//

import Foundation
import Alamofire

public protocol APIRequest {
    associatedtype Response: Decodable

    var baseURL: URL { get }
    var path: String { get }
    var url: URL { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get set }
    var headers: HTTPHeaders? { get set }
    var timeout: TimeInterval { get }
    var encoding: ParameterEncoding { get }
}

// MARK: - extension
extension APIRequest {
    public var baseURL: URL {
        return URL(string: "http://localhost:8080")!
    }
    
    public var url: URL {
        return baseURL.appendingPathComponent(path)
    }
    
    public var parameters: Alamofire.Parameters? {
        return nil
    }
    
    public var headers: Alamofire.HTTPHeaders? {
        return nil
    }
    
    public var timeout: TimeInterval {
        return 30.0
    }
    
    public var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}

public protocol GetRequest: APIRequest {}
extension GetRequest {
    public var method: HTTPMethod {
        return .get
    }
    
    public var encoding: ParameterEncoding {
        return URLEncoding.queryString
    }
}

public protocol PostRequest: APIRequest {}
extension PostRequest {
    public var method: HTTPMethod {
        return .post
    }
}

public protocol PutRequest: APIRequest {}
extension PutRequest {
    public var method: HTTPMethod {
        return .put
    }
}

public protocol DeleteRequest: APIRequest {}
extension DeleteRequest {
    public var method: HTTPMethod {
        return .delete
    }
}
