//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/06/18.
//

import Foundation
import Alamofire

/// 投稿削除
public struct DeletePostRequest: DeleteRequest {
    public typealias Response = DeletePostResponse
    
    public var path: String {
        return "/post"
    }
    
    public var headers: HTTPHeaders?
    public var parameters: Parameters?
    
    public init(deletePostId: Int) {
        parameters = [
            "post_id": deletePostId
        ]
    }
}

public struct DeletePostResponse: Decodable {
}

