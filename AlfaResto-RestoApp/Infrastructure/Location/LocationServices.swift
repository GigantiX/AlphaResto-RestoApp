//
//  LocationServices.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 26/06/24.
//

import UIKit
import CoreLocation
import RxSwift

protocol LocationServices {
    func requestPremission()
    func getStatusPermission() -> CLAuthorizationStatus
    func setLocationDelegate(_ vc: UIViewController)
    func startUpdatingLocation()
    func stopUpdatingLocation()
}

final class LocationServicesImpl {
    
    private let locationManager: CLLocationManager
    
    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
    }
    
}

extension LocationServicesImpl: LocationServices {
    func requestPremission() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.distanceFilter = 50
    }
    
    func getStatusPermission() -> CLAuthorizationStatus {
        locationManager.authorizationStatus
    }
    
    func setLocationDelegate(_ vc: UIViewController) {
        locationManager.delegate = vc as? any CLLocationManagerDelegate
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}
