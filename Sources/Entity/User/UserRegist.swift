//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/20.
//

import Foundation

public struct UserRegist: Equatable {
    public var accountId: String?
    public var acountName: String?
    public var profileImage: Data?
    public var isMusician: Bool = false
    
    public init() {}
}

// MARK: - extension

extension UserRegist {
    public static func stub() -> Self {
        var userRegist = Self()
        userRegist.accountId = ""
        userRegist.acountName = ""
        userRegist.profileImage = Data()
        
        return userRegist
    }
}
