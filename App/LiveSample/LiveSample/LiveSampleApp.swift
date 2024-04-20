//
//  LiveSampleApp.swift
//  LiveSample
//
//  Created by 鈴木登也 on 2024/02/04.
//

import SwiftUI
import ComposableArchitecture
import Root
import RootStore
import Routing

@main
struct LiveSampleApp: App {
    @StateObject var loginRouter = LoginRouter()
    @StateObject var router = NavigationRouter()
    
    var body: some Scene {
        WindowGroup {
            RootView(
                store: Store(
                    initialState: Root.State()) {
                        Root()
                    }
            )
            .environmentObject(self.loginRouter)
            .environmentObject(self.router)
        }
    }
}
