//
//  File.swift
//
//
//  Created by 鈴木登也 on 2024/05/04.
//

import SwiftUI
import MapKit

final public class LocationManager: NSObject, ObservableObject {
    @Published public var region: MKCoordinateRegion?
    private let manager = CLLocationManager()
    public static var shared = LocationManager()
    
    private override init() {
        super.init()
        
        self.manager.delegate = self
        self.manager.requestWhenInUseAuthorization()
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.distanceFilter = 2
        self.manager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("check: Location authorization status changed to '\(status == .authorizedAlways ? "authorizedAlways" : "authorizedWhenInUse")'")
        case .denied, .restricted:
            print("check: Location authorization status changed to '\(status == .denied ? "denied" : "restricted")'")
        case .notDetermined:
            print("check: Location authorization status changed to 'notDetermined'")
        default:
            print("check: Location authorization status changed to unknown status '\(status)'")
        }
    }
        
    // 位置情報が更新されたら呼び出される
    public func locationManager(_ manager: CLLocationManager,
                                didUpdateLocations locations: [CLLocation]) {
        
        locations.last.map {
            let center = CLLocationCoordinate2D(
                latitude: $0.coordinate.latitude,
                longitude: $0.coordinate.longitude)
            
            // 地図を表示するための領域を再構築
            self.region = MKCoordinateRegion(
                center: center,
                latitudinalMeters: 1000.0,
                longitudinalMeters: 1000.0
            )
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("check: Location manager failed with error: \(error)")
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("check: Location manager Did change Authorization: \(manager.authorizationStatus)")
    }
}
