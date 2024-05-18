//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/04/24.
//

import Foundation

public struct PostEntity: Equatable {
    public var imagePath: String
    public var freeText: String
    public var coordinateX: String
    public var coordinateY: String
    public var startDateTime: String
    public var endDateTime: String
    
    public init(imagePath: String, freeText: String, coordinateX: String, coordinateY: String, startDateTime: String, endDateTime: String) {
        self.imagePath = imagePath
        self.freeText = freeText
        self.coordinateX = coordinateX
        self.coordinateY = coordinateY
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
    }
}

extension PostEntity {
    public static func stub() -> Self {
        return .init(imagePath: "", freeText: "", coordinateX: "", coordinateY: "", startDateTime: "", endDateTime: "")
    }

}


