//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/22.
//

import Foundation
import Alamofire

/// プロフィール写真登録
public struct UploadProfilePictureRequest: PostRequest {
    public typealias Response = UploadProfilePictureResponse
    
    public var path: String {
        return "/image/upload"
    }
    
    public var headers: HTTPHeaders?
    public var parameters: Parameters?
    
    public init(data: Data) {
        parameters = [
            "image": data
        ]
    }
}

public struct UploadProfilePictureResponse: Decodable {
    public var imagePath: String
}
