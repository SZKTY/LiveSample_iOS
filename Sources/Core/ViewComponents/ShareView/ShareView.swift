//
//  File.swift
//  
//
//  Created by toya.suzuki on 2024/06/28.
//

import SwiftUI
import Share

public struct ShareView: UIViewControllerRepresentable {
    private let imageData: Data
    private let description: String
    private let url: URL?
    
    public init(imageData: Data, description: String, url: URL?) {
        self.imageData = imageData
        self.description = description
        self.url = url
    }
    
    public func makeUIViewController(context: Context) -> UIActivityViewController {
        let item = ShareActivityItemSource(imageData, title: description, url: url)
        let activityViewController = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        return activityViewController
    }
    
    public func updateUIViewController(_ vc: UIActivityViewController, context: Context) {
    }
}
