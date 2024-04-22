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
    var baseURL: URL {
//        return URL(string: Constants.Api.baseURL)!
        return URL(string: "")!
    }
    
    var url: URL {
        return baseURL.appendingPathComponent(path)
    }
    
    var parameters: Alamofire.Parameters? {
        return nil
    }
    
    var headers: Alamofire.HTTPHeaders? {
        return nil
    }
    
    var timeout: TimeInterval {
        return 30.0
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}

protocol GetRequest: APIRequest {}
extension GetRequest {
    var method: HTTPMethod {
        return .get
    }
    
    var encoding: ParameterEncoding {
        return URLEncoding.queryString
    }
}

protocol PostRequest: APIRequest {}
extension PostRequest {
    var method: HTTPMethod {
        return .post
    }
}

protocol PutRequest: APIRequest {}
extension PutRequest {
    var method: HTTPMethod {
        return .put
    }
}

protocol DeleteRequest: APIRequest {}
extension DeleteRequest {
    var method: HTTPMethod {
        return .delete
    }
}
