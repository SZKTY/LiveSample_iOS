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
                ZStack {
                    // マップ表示
                    MapViewComponent()
                        .setCallback(didLongPress: {
                            // do nothing
                            print("check: didLongPress")
                        }, didChangeCenterRegion: { location in
                            viewStore.send(.centerRegionChanged(region: location))
                        })
                    
                    // 投稿作成ボタン
                    FloatingButton {
                        viewStore.send(.floatingButtonTapped)
                    }
                    .opacity(viewStore.isSelectPlaceMode ? 0 : 1)
                    
                    // 場所選択モード
                    SelectPLaceModeView {
                        viewStore.send(.confirmButtonTappedInSelectPlaceMode)
                    } cancelAction: {
                        viewStore.send(.cancelButtonTappedInSelectPlaceMode)
                    }
                    .opacity(viewStore.isSelectPlaceMode ? 1 : 0)
                    
                }
                .edgesIgnoringSafeArea(.top)
            }
            .navigationDestination(
                store: store.scope(state: \.$destination.post,
                                   action: \.destination.post)
            ) { store in
                self.postView(store)
            }
        }
    }
}

public struct SelectPLaceModeView: View {
    public let action: () -> ()
    public let cancelAction: () -> ()
    
    public init(action: @escaping () -> Void,
                cancelAction: @escaping () -> Void) {
        self.action = action
        self.cancelAction = cancelAction
    }
    
    public var body: some View {
        ZStack {
            Color.gray.opacity(0.5)
                .ignoresSafeArea()
                .allowsHitTesting(false)
            
            VStack {
                HStack {
                    HStack {
                        Spacer()
                            .frame(width: 2.0)
                        
                        Button(action: {
                            self.cancelAction()
                        }, label: {
                            HStack(spacing: 4.0) {
                                Image(systemName: "xmark")
                                Text("Cancel")
                            }
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                        })
                        .frame(width: 100, height: 36)
                        
                        Spacer(minLength: 0)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Text("開催場所を指定")
                        .font(.system(size: 16))
                        .bold()
                        .lineLimit(1)
                        .layoutPriority(1)
                    
                    HStack {
                        Spacer(minLength: 0)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.top, 44)
                
                Spacer()
                
                Image(systemName: "scope")
                    .foregroundColor(.black)
                    .font(.system(size: 36))
                
                
                Spacer()
                
                Button(action: {
                    self.action()
                }, label: {
                    Text("確定")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .bold()
                })
                .frame(width: 120.0, height: 60.0)
                .background(.black)
                .cornerRadius(6)
                .padding(.bottom, 42.0)
            }
        }
    }
}
