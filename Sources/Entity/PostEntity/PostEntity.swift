//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/24.
//

import Foundation

public struct PostEntity: Equatable {
    public var image: Data?
    public var freeText: String?
    public var coordinateX: String
    public var coordinateY: String
    public var startDateTime: String
    public var endDateTime: String
}

extension PostEntity {
    public static func stub() -> Self {
        var post = Self(coordinateX: "", coordinateY: "", startDateTime: "", endDateTime: "")
        
        return post
    }

}


