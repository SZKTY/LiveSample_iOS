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
        parameters = [
            "coordinate_x": param.coordinateX,
            "coordinate_y": param.coordinateY,
            "start_datetime": param.startDateTime,
            "end_datetime": param.endDateTime
        ]
        
        if !param.imagePath.isEmpty {
            parameters?["image_path"] = param.imagePath
        }
        
        if !param.freeText.isEmpty {
            parameters?["free_text"] = param.freeText
        }
    }
}

public struct CreatePostResponse: Decodable {
    var postId: Int
}
