//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/05/13.
//

import Foundation
import Alamofire

/// プロフィール写真登録
public struct RegisterProfilePictureRequest: PostRequest {
    public typealias Response = RegisterProfilePictureResponse
    
    public var path: String {
        return "/users/profile/image"
    }
    
    public var headers: HTTPHeaders?
    public var parameters: Parameters?
    
    public init(path: String) {
        parameters = [
            "profile_image_path": path
        ]
    }
}

public struct RegisterProfilePictureResponse: Decodable {
}

