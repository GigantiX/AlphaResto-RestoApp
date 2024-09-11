//
//  LocationRepository.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 26/06/24.
//

import UIKit
import CoreLocation
import RxSwift
import GoogleMaps

protocol LocationRepository {
    var disposeBag: DisposeBag { get }
    
    func requestPremission()
    func getStatusPermission() -> CLAuthorizationStatus
    func setLocationDelegate(_ vc: UIViewController)
    func startUpdatingLocation()
    func stopUpdatingLocation()
    func getDirectionMaps(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, googleAPIkey: String) -> Observable<GMSPolyline>   
    func setValue<T: Codable>(modelValue: T, type: ReferenceRealTimeDatabaseType) -> Completable
    func observerValue<T: Codable>(type: ReferenceRealTimeDatabaseType) -> Single<T?>
    func deleteValue(type: ReferenceRealTimeDatabaseType) -> Completable
}
