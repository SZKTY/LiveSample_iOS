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
    
    public init(imageData: Data, description: String) {
        self.imageData = imageData
        self.description = description
    }
    
    public func makeUIViewController(context: Context) -> UIActivityViewController {
        let description = "setsumeibun ga hairimasu"
        // ストアリンク？
        let url = URL(string: "https://qiita.com/shiz/items/93a33446f289a8a9b65d")!
        let item = ShareActivityItemSource(imageData, title: description, url: url)
        let activityViewController = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        return activityViewController
    }
    
    public func updateUIViewController(_ vc: UIActivityViewController, context: Context) {
    }
}
