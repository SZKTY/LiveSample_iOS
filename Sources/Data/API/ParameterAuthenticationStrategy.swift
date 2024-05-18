//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/22.
//

import Foundation

public class ParameterAuthenticationStrategy: AuthenticateStrategy {
    public init() {}
    
    public func addAuthInfo<T: APIRequest>(to request: T, token: String) -> T {
        var origin = request
        
        if origin.headers == nil {
            origin.headers = [:]
        }
        
        origin.headers!["X-Inemuri-Session-Id"] = token
        
        return origin
    }
}
