//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/06/18.
//

import Foundation
import Alamofire

///  ユーザー情報取得
public struct GetUserInfoRequest: GetRequest {
    public typealias Response = GetUserInfoResponse
    
    public var path: String {
        return "/users/info"
    }
    
    public var headers: HTTPHeaders?
    public var parameters: Parameters?
    
    public init() {}
}

public struct GetUserInfoResponse: Decodable {
    public var accountName: String
    public var accountId: String
    public var userId: Int
    public var accountType: String
    public var accountImagePath: String
}
