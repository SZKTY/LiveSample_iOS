//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/22.
//

import Foundation
import Alamofire

/// 写真登録
public struct UploadPictureRequest: PostRequest {
    public typealias Response = UploadPictureResponse
    
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

public struct UploadPictureResponse: Decodable {
    public var imagePath: String
    
    public init(imagePath: String) {
        self.imagePath = imagePath
    }
}
