//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/05/04.
//

import ComposableArchitecture
import SwiftUI
import ViewComponents
import MapWithCrossStore
import MapKit

public struct MapWithCrossView: View {
    let store: StoreOf<MapWithCrossStore>
    
    public init(store: StoreOf<MapWithCrossStore>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            GeometryReader { geometry in
                ZStack {
                    // マップ表示
                    MapViewComponent(
                        region: MKCoordinateRegion(
                            center: viewStore.center,
                            latitudinalMeters: 1000.0,
                            longitudinalMeters: 1000.0
                        )
                    )
                    .setCallback(didLongPress: {
                        // do nothing
                        print("check: didLongPress")
                    }, didChangeCenterRegion: { center in
                        viewStore.send(.centerRegionChanged(location: center))
                    })
                    
                    // 場所選択モード
                    SelectPLaceModeView(scopeTopPadding: geometry.safeAreaInsets.top, action: {
                        viewStore.send(.determineButtonTapped)
                    }, cancelAction: {
                        viewStore.send(.cancelButtonTapped)
                    })
                }
                .edgesIgnoringSafeArea(.top)
                .navigationBarBackButtonHidden()
            }
        }
    }
}

