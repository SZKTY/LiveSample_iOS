//
//  File.swift
//
//
//  Created by toya.suzuki on 2024/04/08.
//

import SwiftUI
import ComposableArchitecture
import TopTabStore
import Map
import MapStore
import MyPage
import MyPageStore

public struct TopTabView: View {
    let store: StoreOf<TopTab>
    
    public init(store: StoreOf<TopTab>) {
        self.store = store
    }
    
    public var body: some View {
        TabView {
            MapView(store: Store(
                initialState: MapStore.State()) {
                    MapStore()
                }
            )
            .tabItem {
                Label("マップ", systemImage: "1.circle")
            }
            
            MyPageView(store: Store(
                initialState: MyPage.State()) {
                    MyPage()
                }
            )
            .tabItem {
                Label("マイページ", systemImage: "2.circle")
            }
        }
    }
}

