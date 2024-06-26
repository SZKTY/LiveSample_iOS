//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/05/04.
//

import ComposableArchitecture
import SwiftUI
import MapKit
import MapWithCrossStore
import ViewComponents

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
                    MapViewRepresentable(
                        postAnnotations: nil,
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
                    }, didTapPin: { _ in
                        print("check: didTapPin")
                    })
                    
                    // 場所選択モード
                    SelectPLaceModeView(scopeTopPadding: geometry.safeAreaInsets.top, action: {
                        DispatchQueue.main.async {
                            viewStore.send(.determineButtonTapped)
                        }
                    }, cancelAction: {
                        DispatchQueue.main.async {
                            viewStore.send(.cancelButtonTapped)
                        }
                    })
                }
                .edgesIgnoringSafeArea(.vertical)
                .navigationBarBackButtonHidden()
            }
        }
    }
}

