//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/05/11.
//

import Foundation
import Alamofire
import PostEntity

/// アカウント発行
public struct CreatePostRequest: PostRequest {
    public typealias Response = CreatePostResponse
    
    public var path: String {
        return "/post"
    }
    
    public var headers: HTTPHeaders?
    public var parameters: Parameters?
    
    public init(param: PostEntity) {
        parameters = [:]
    }
}

public struct CreatePostResponse: Decodable {
    
}
