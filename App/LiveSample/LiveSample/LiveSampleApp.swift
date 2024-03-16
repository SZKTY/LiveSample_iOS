//
//  LiveSampleApp.swift
//  LiveSample
//
//  Created by 鈴木登也 on 2024/02/04.
//

import SwiftUI
import ComposableArchitecture
import SampleCounter

@main
struct LiveSampleApp: App {
    var body: some Scene {
        WindowGroup {
            SampleCounterView(
                store: Store(
                    initialState: SampleCounter.State()) {
                        SampleCounter()
                    }
            )
        }
    }
}
