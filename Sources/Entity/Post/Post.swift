//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/24.
//

import Foundation

public struct Post: Equatable {
    public var image: Data?
    public var freeText: String?
    public var coordinateX: String?
    public var coordinateY: String?
    public var startDateTime: String?
    public var endDateTime: String?
}

extension Post {
    public static func stub() -> Self {
        var post = Self()
        post.image = Data()
        post.freeText = ""
        post.coordinateX = ""
        post.coordinateY = ""
        post.startDateTime = ""
        post.endDateTime = ""
        
        return post
    }

}


