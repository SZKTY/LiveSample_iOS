//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/11/24.
//

import Foundation
import Alamofire

/// パスワードリセット認証開始API
public struct ResetPasswordStartVerificationRequest: PostRequest {
    public typealias Response = ResetPasswordStartVerificationResponse
    
    public var path: String {
        return "/password/reset/verification/start"
    }
    
    public var headers: HTTPHeaders?
    public var parameters: Parameters?
    
    public init(email: String) {
        parameters = [
            "email": email
        ]
    }
}

public struct ResetPasswordStartVerificationResponse: Decodable {
}
