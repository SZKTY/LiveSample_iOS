//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/05/04.
//

import SwiftUI
import MapKit
import Location

public struct MapViewRepresentable: UIViewRepresentable {
    @StateObject private var manager = LocationManager.shared
    private var didLongPressCallback: (() -> Void)?
    private var didChangeCenterRegionCallback: ((CLLocationCoordinate2D) -> Void)?
    private var isFirst: Bool = true
    private var region: MKCoordinateRegion?
    
    public init(region: MKCoordinateRegion? = nil) {
        if region != nil {
            self.region = region
            self.isFirst = false
        }
    }
    
    // 初期化
    public func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        if let region = self.region {
            mapView.setRegion(region, animated: false)
        }
        
        let longPressed = UILongPressGestureRecognizer(target: context.coordinator,
                                                       action: #selector(context.coordinator.didLongPress(_:)))
        mapView.addGestureRecognizer(longPressed)
        
        return mapView
    }
    
    // 更新時
    public func updateUIView(_ uiView: MKMapView, context: Context) {
        context.coordinator.didLongPressCallback = self.didLongPressCallback
        context.coordinator.didChangeCenterRegionCallback = self.didChangeCenterRegionCallback
        
        // 位置の設定は初回のみ
        if let region = self.manager.region, context.coordinator.isFirst, self.region == nil {
            context.coordinator.isFirst = false
            uiView.setRegion(region, animated: false)
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    /// コールバックをMapViewから指定
    /// - Parameters:
    ///   - didLongPress: ロングタップされた際のコールバック
    ///   - didChangeCenterRegion: 中心座標が変わった際のコールバック
    /// - Returns: Self
    public func setCallback(didLongPress: @escaping () -> Void,
                            didChangeCenterRegion: @escaping (CLLocationCoordinate2D) -> Void) -> Self {
        var ret = self
        ret.didLongPressCallback = didLongPress
        ret.didChangeCenterRegionCallback = didChangeCenterRegion
        return ret
    }
    
    public class Coordinator: NSObject, MKMapViewDelegate {
        var didLongPressCallback: (() -> Void)?
        var didChangeCenterRegionCallback: ((CLLocationCoordinate2D) -> Void)?
        
        init(_ parent: MapViewRepresentable) {
            self.parent = parent
        }
        
        private var parent: MapViewRepresentable
        var isFirst: Bool = true
        
        // 中心の座標を取得
        public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            self.didChangeCenterRegionCallback?(mapView.region.center)
        }
        
        @objc func didLongPress(_ gestureRecognizer:UIGestureRecognizer) {
            if gestureRecognizer.state == .began {
                self.didLongPressCallback?()
            }
        }
        
        public func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            print("check: Did Update User location\(userLocation.coordinate)")
        }
        
        public func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
            print("check: Map will start loading")
        }
        public func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
            print("check: Map did finish loading")
        }
        
        public func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
            print("check: Map will start locating user")
        }
        
        public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            return nil
        }
    }
}
