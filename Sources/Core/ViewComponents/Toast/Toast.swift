//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/06/08.
//

import SwiftUI

struct Toast: View {
    let message: Message
    let layout: Layout
    let onClose: () -> Void
    @State private var isShowing: Bool = false

    var body: some View {
        VStack {
            Spacer()
            if isShowing {
                message.content
                    .onTapGesture {
                        isShowing = false
                    }
                    .task {
                        try? await Task.sleep(for: message.config.duration)
                        isShowing = false
                        // アニメーションが終わるのを適当な時間待つ
                        // (animation から duration が取得できないので)
                        try? await Task.sleep(for: .seconds(1))
                        onClose()
                    }
            }
        }
        .padding(layout.padding)
        .animation(message.config.animation, value: isShowing)
        .transition(message.config.transition)
        .onAppear {
            isShowing = true
        }
    }

    struct Message: Identifiable {
        let id = UUID()
        let content: AnyView
        let config: Config
    }

    struct Config {
        let duration: Duration
        let transition: AnyTransition
        let animation: Animation
    }

    struct Layout {
        let padding: EdgeInsets
    }
}
