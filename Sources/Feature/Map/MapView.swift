//
//  SwiftUIView.swift
//
//
//  Created by toya.suzuki on 2024/04/24.
//

import SwiftUI
import ComposableArchitecture
import PopupView
import MapStore
import MapKit
import Routing
import ViewComponents

public struct MapView: View {
    @EnvironmentObject var accountTypeChecker: AccountTypeChecker
    
    @Dependency(\.viewBuildingClient.postView) private var postView
    @Dependency(\.viewBuildingClient.myPageView) private var myPageView
    @Dependency(\.viewBuildingClient.postDetailView) private var postDetailView
    @Dependency(\.viewBuildingClient.editProfileView) private var editProfileView
    
    private let store: StoreOf<MapStore>
    
    public nonisolated init(store: StoreOf<MapStore>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                WithViewStore(self.store, observe: { $0 }) { viewStore in
                    ZStack {
                        // マップ表示
                        MapViewRepresentable(postAnnotations: viewStore.$postAnnotations,
                                             isShownPostDetailSheet: viewStore.isShownPostDetailSheet)
                        .setCallback(didLongPress: {
                            // do nothing
                            print("check: didLongPress")
                        }, didChangeCenterRegion: { region in
                            DispatchQueue.main.async {
                                viewStore.send(.centerRegionChanged(region: region))
                            }
                        }, didTapPin: { annotation in
                            viewStore.send(.annotationTapped(annotation: annotation))
                        })
                        
                        // マイページボタン
                        FloatingButton(position: .topLeading, imageName: "line.3.horizontal", isBaseColor: false) {
                            DispatchQueue.main.async {
                                viewStore.send(.floatingHomeButtonTapped)
                            }
                        }
                        .opacity(viewStore.isSelectPlaceMode ? 0 : 1)
                        
                        // 投稿作成ボタン
                        FloatingButton(position: .bottomTailing, imageName: "plus") {
                            DispatchQueue.main.async {
                                viewStore.send(.floatingPlusButtonTapped)
                            }
                        }
                        .opacity(accountTypeChecker.accountType == .artist && !viewStore.isSelectPlaceMode ? 1 : 0)
                        
                        // 場所選択モード
                        SelectPLaceModeView(scopeTopPadding: geometry.safeAreaInsets.top, action: {
                            DispatchQueue.main.async {
                                viewStore.send(.confirmButtonTappedInSelectPlaceMode)
                            }
                        }, cancelAction: {
                            DispatchQueue.main.async {
                                viewStore.send(.cancelButtonTappedInSelectPlaceMode)
                            }
                        })
                        .opacity(viewStore.isSelectPlaceMode ? 1 : 0)
                    }
                    .popup(isPresented: viewStore.$isShowSuccessToast) {
                        // 投稿作成完了のトーストバナー
                        SuccessToastBanner()
                    } customize: {
                        $0
                            .type(.floater())
                            .position(.top)
                            .animation(.spring)
                            .autohideIn(3)
                        
                    }
                }
            }
            .edgesIgnoringSafeArea(.vertical)
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.didSuccessCreatePost)) { notification in
                store.send(.showSuccessToast)
            }
            .task {
                await store.send(.task).finish()
            }
            .alert(
                store: store.scope(state: \.$alert,
                                   action: \.alert)
            )
            .navigationDestination(
                store: store.scope(state: \.$destination.post,
                                   action: \.destination.post)
            ) { store in
                postView(store)
            }
            .navigationDestination(
                store: store.scope(state: \.$destination.editProfile,
                                   action: \.destination.editProfile)
            ) { store in
                editProfileView(store)
            }
            .sheet(
                store: store.scope(state: \.$myPage,
                                   action: \.myPage),
                onDismiss: {
                    store.send(.myPageSheetDismiss)
                }
            ) { store in
                myPageView(store)
            }
            .sheet(
                store: store.scope(state: \.$postDetail,
                                   action: \.postDetail),
                onDismiss: {
                    store.send(.postDetailSheetDismiss)
                }
            ) { store in
                postDetailView(store)
                    .presentationDetents([
                        .fraction(0.8)
                    ])
            }
        }
    }
}
