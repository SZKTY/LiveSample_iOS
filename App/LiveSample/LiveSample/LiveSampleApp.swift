//
//  LiveSampleApp.swift
//  LiveSample
//
//  Created by 鈴木登也 on 2024/02/04.
//

import SwiftUI
import ComposableArchitecture
import TicketFeature

@main
struct LiveSampleApp: App {
    var body: some Scene {
        WindowGroup {
            TicketsView(
                store: Store(
                    initialState: TicketsState(),
                    reducer: TicketsReducer()
                )
            )
        }
    }
}
