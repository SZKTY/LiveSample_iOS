//
//  File.swift
//  
//
//  Created by 鈴木登也 on 2024/05/04.
//

import SwiftUI
import MapKit
import Location
import PostAnnotation
import DateUtils
import Extensions
import Assets

public struct MapViewRepresentable: UIViewRepresentable {
    @StateObject private var manager = LocationManager.shared
    @Binding private var postAnnotations: [PostAnnotation]
    
    private var didLongPressCallback: (() -> Void)?
    private var didChangeCenterRegionCallback: ((CLLocationCoordinate2D) -> Void)?
    private var didTapPinCallback: ((PostAnnotation) -> Void)?
    
    private var isFirst: Bool = true
    private var isShownPostDetailSheet: Bool = false
    private var region: MKCoordinateRegion?
    
    public init(
        postAnnotations: Binding<[PostAnnotation]>?,
        isShownPostDetailSheet: Bool = false,
        region: MKCoordinateRegion? = nil
    ) {
        _postAnnotations = postAnnotations ?? .constant([])
        self.isShownPostDetailSheet = isShownPostDetailSheet
        
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
            let pin = MKPointAnnotation()
            let coordinate: CLLocationCoordinate2D = .init(latitude: region.center.latitude, longitude: region.center.longitude)
            pin.coordinate = coordinate
            mapView.addAnnotation(pin)
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
        context.coordinator.didTapPinCallback = self.didTapPinCallback
        
        // 位置の設定は初回のみ
        if let region = self.manager.region, context.coordinator.isFirst, self.region == nil {
            context.coordinator.isFirst = false
            uiView.setRegion(region, animated: false)
        }
        
        // 投稿詳細を表示している際は、シート上にピンが表示されるようにマップの中央をずらす
        if isShownPostDetailSheet {
            guard let annotation = context.coordinator.selectedAnnotation else { return }
            setCenter(from: annotation, mapView: uiView)
        }
        
        context.coordinator.updateAnnotations(uiView, postAnnotations: postAnnotations)
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
                            didChangeCenterRegion: @escaping (CLLocationCoordinate2D) -> Void,
                            didTapPin: @escaping (PostAnnotation) -> Void) -> Self {
        var ret = self
        ret.didLongPressCallback = didLongPress
        ret.didChangeCenterRegionCallback = didChangeCenterRegion
        ret.didTapPinCallback = didTapPin
        return ret
    }
    
    /// 任意のPostAnnotationをMapView中央に表示（ピンタップ時に動かす用）
    /// - Parameters:
    ///   - annotation: マップ中央に表示したいPostAnnotation
    ///   - mapView: 表示中のMapView
    private func setCenter(from annotation: PostAnnotation, mapView: MKMapView) {
        guard let lat = Double(annotation.coordinateX),
              let long = Double(annotation.coordinateY) else { return }
        
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: lat - 0.0008 , longitude: long),
            latitudinalMeters: 120.0,
            longitudinalMeters: 120.0
        )
        
        mapView.setRegion(region, animated: true)
    }
    
    public class Coordinator: NSObject, MKMapViewDelegate {
        var didLongPressCallback: (() -> Void)?
        var didChangeCenterRegionCallback: ((CLLocationCoordinate2D) -> Void)?
        var didTapPinCallback: ((PostAnnotation) -> Void)?
        var selectedAnnotation: PostAnnotation?
        
        init(_ parent: MapViewRepresentable) {
            self.parent = parent
        }
        
        private var parent: MapViewRepresentable
        var isFirst: Bool = true
        
        public func updateAnnotations(_ mapView: MKMapView, postAnnotations: [PostAnnotation]) {
            // TODO: PinにユニークのIDを持たせ、既にマップへ追加済み or 既に投稿が削除済みか比較できるようにする
            // TODO: マップ中央から半径何キロ以内みたいなバリデーションを追加する
            
            // ピンを全消しする
            if !mapView.annotations.isEmpty {
                mapView.removeAnnotations(mapView.annotations)
            }
            
            // postが存在する時はピンを追加する
            postAnnotations.forEach { annotation in
                guard let lat = Double(annotation.coordinateX),
                      let long = Double(annotation.coordinateY) else { return }
                annotation.coordinate = CLLocationCoordinate2DMake(lat, long)
                mapView.addAnnotation(annotation)
            }
        }
        
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
            guard let _annotation = annotation as? PostAnnotation else { return nil }
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annotationView.markerTintColor = getMarkerTintColor(from: _annotation.startDatetime)
            return annotationView
        }
        
        public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let annotation = view.annotation as? PostAnnotation else { return }
            selectedAnnotation = annotation
            didTapPinCallback?(annotation)
        }
        
        private func getMarkerTintColor(from startDate: String) -> UIColor {
            let date = DateUtils.dateFromString(string: startDate, format: "yyyy-MM-dd'T'HH:mm:ssZ")
            let diffInHours = date.timeIntervalSince(Date()) / 3600
            
            switch diffInHours {
            case ..<1:
                return .init(hex: "FF3A3E", alpha: 1.0) // 1時間以内
            case 1..<12:
                return .init(hex: "60DE73", alpha: 0.8) // 12時間以内
            case 12..<24:
                return .init(hex: "6A67EE", alpha: 0.8) // 24時間以内
            default:
                return .init(hex: "8D8D8D", alpha: 0.8) // それ以降
            }
        }
    }
}
