//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/06/14.
//

import Foundation
import MapKit

public class PostAnnotation: MKPointAnnotation {
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

extension PostAnnotation {
    public static func stub() -> PostAnnotation {
        return .init(imagePath: "", freeText: "やほー", coordinateX: "", coordinateY: "", startDateTime: "", endDateTime: "")
    }
    
//    public static func convert(from request: ) -> Self {
//        return .init(imagePath: "", freeText: "", coordinateX: "", coordinateY: "", startDateTime: "", endDateTime: "")
//    }

}
