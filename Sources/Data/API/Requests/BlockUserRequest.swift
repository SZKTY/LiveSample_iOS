//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/06/18.
//

import Foundation
import Alamofire

/// ユーザーブロック
public struct BlockUserRequest: PostRequest {
    public typealias Response = BlockUserResponse
    
    public var path: String {
        return "/user/block"
    }
    
    public var headers: HTTPHeaders?
    public var parameters: Parameters?
    
    public init(blockUserId: Int) {
        parameters = [
            "block_user_id": blockUserId
        ]
    }
}

public struct BlockUserResponse: Decodable {
}
