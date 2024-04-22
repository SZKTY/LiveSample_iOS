//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/22.
//

import Foundation
import Alamofire

/// プロフィール写真登録
struct ProfilePictureRegistRequest: PutRequest {
    typealias Response = ProfilePictureRegistResponse
    
    var path: String {
        return ""
    }
    
    var headers: HTTPHeaders?
    var parameters: Parameters?
    
    init(data: Data) {
        parameters = [
            "data": data
        ]
    }
}

struct ProfilePictureRegistResponse: Decodable {
    
}
