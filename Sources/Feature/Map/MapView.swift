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
    @Dependency(\.viewBuildingClient.myPageView) private var myPageView
    @Dependency(\.viewBuildingClient.postDetailView) private var postDetailView
    private let store: StoreOf<MapStore>
    
    public nonisolated init(store: StoreOf<MapStore>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                mapView(geometry: geometry)
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.didSuccessCreatePost)) { notification in
                store.send(.showSuccessToast)
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
            .navigationDestination(
                store: store.scope(state: \.$destination.myPage,
                                   action: \.destination.myPage)
            ) { store in
                self.myPageView(store)
            }
            .sheet(
                store: store.scope(state: \.$postDetail,
                                   action: \.postDetail),
                onDismiss: {
                    store.send(.postDetailSheetDismiss)
                }
            ) { store in
                self.postDetailView(store)
                    .presentationDetents([
                        .fraction(0.8)
                    ])
            }
            
        }
    }
    
    func mapView(geometry: GeometryProxy) -> some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                // マップ表示
                MapViewRepresentable(postAnnotations: viewStore.postAnnotations,
                                     isShownPostDetailSheet: viewStore.isShownPostDetailSheet)
                    .setCallback(didLongPress: {
                        // do nothing
                        print("check: didLongPress")
                    }, didChangeCenterRegion: { region in
                        viewStore.send(.centerRegionChanged(region: region))
                    }, didTapPin: { annotation in
                        viewStore.send(.annotationTapped(annotation: annotation))
                    })
                
                // マイページボタン
                FloatingButton(position: .topLeading, imageName: "house") {
                    viewStore.send(.floatingHomeButtonTapped)
                }
                .opacity(viewStore.isSelectPlaceMode ? 0 : 1)
                
                // 投稿作成ボタン
                FloatingButton(position: .bottomTailing, imageName: "plus") {
                    viewStore.send(.floatingPlusButtonTapped)
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
                    SuccessToastBanner(onAppear: {
                        viewStore.send(.hideSuccessToast)
                    })
                }
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
}
