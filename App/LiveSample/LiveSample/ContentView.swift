//
//  ContentView.swift
//  LiveSample
//
//  Created by 鈴木登也 on 2024/02/04.
//

import SwiftUI
import Sample

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world! \(Sample().count)")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
