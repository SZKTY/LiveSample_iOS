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

public struct MapView: View {
    @State private var region = MKCoordinateRegion()
    let store: StoreOf<MapStore>
    
    public init(store: StoreOf<MapStore>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Map(coordinateRegion: $region,
                //Mapの操作の指定
                interactionModes: .zoom,
                //現在地の表示
                showsUserLocation: true,
                //現在地の追従
                userTrackingMode: .constant(MapUserTrackingMode.follow)
            )
            .task() {
                //位置情報へのアクセスを要求
                let manager = CLLocationManager()
                manager.requestWhenInUseAuthorization()
            }
        }
    }
}
