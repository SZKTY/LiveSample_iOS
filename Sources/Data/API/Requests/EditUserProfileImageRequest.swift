//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/06/28.
//

import Foundation
import Alamofire

/// ユーザープロフィール画像編集
public struct EditUserProfileImageRequest: PutRequest {
    public typealias Response = EditUserProfileImageResponse
    
    public var path: String {
        return "/users/profile/image"
    }
    
    public var headers: HTTPHeaders?
    public var parameters: Parameters?
    
    public init(path: String) {
        self.parameters = [
            "image_path": path
        ]
    }
}

public struct EditUserProfileImageResponse: Decodable {
}
