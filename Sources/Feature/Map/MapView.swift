//
//  SwiftUIView.swift
//
//
//  Created by toya.suzuki on 2024/04/24.
//

import SwiftUI
import ComposableArchitecture
import MapStore
import MapKit
import Location
import Routing
import ViewComponents

public struct MapView: View {
    @Dependency(\.viewBuildingClient.postView) private var postView
    private let store: StoreOf<MapStore>
    
    public nonisolated init(store: StoreOf<MapStore>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                GeometryReader { geometry in
                    ZStack {
                        // マップ表示
                        MapViewRepresentable()
                            .setCallback(didLongPress: {
                                // do nothing
                                print("check: didLongPress")
                            }, didChangeCenterRegion: { region in
                                viewStore.send(.centerRegionChanged(region: region))
                            })
                        
                        // 投稿作成ボタン
                        FloatingButton {
                            viewStore.send(.floatingButtonTapped)
                        }
                        .opacity(viewStore.isSelectPlaceMode ? 0 : 1)
                        
                        // 場所選択モード
                        SelectPLaceModeView(scopeTopPadding: geometry.safeAreaInsets.top, action: {
                            viewStore.send(.confirmButtonTappedInSelectPlaceMode)
                        }, cancelAction: {
                            viewStore.send(.cancelButtonTappedInSelectPlaceMode)
                        })
                        .opacity(viewStore.isSelectPlaceMode ? 1 : 0)
                        
                        // 投稿作成完了のトーストバナー
                        if viewStore.isShowSuccessToast {
                            SuccessToastBanner(showFlag: viewStore.$isShowSuccessToast)
                        }
                    }
                    .edgesIgnoringSafeArea(.top)
                }
            }
            .task {
                await store.send(.task).finish()
            }
            .navigationDestination(
                store: store.scope(state: \.$destination.post,
                                   action: \.destination.post)
            ) { store in
                self.postView(store)
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.didSuccessCreatePost)) { notification in
                store.send(.showSuccessToast)
            }
        }
    }
}
