//
//  LocationUseCase.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 28/06/24.
//

import Foundation
import CoreLocation
import RxSwift
import GoogleMaps

protocol LocationUseCase {
    func executeRequestPremission()
    func executeGetStatusPermission() -> CLAuthorizationStatus
    func executeSetLocationDelegate(_ vc: UIViewController)
    func executeStartUpdatingLocation()
    func executeStopUpdatingLocation()
    func executeSetValue<T: Codable>(modelValue: T, type: ReferenceRealTimeDatabaseType) -> Completable
    func executeObserverValue<T: Codable>(type: ReferenceRealTimeDatabaseType) -> Single<T?>
    func executeDeleteValue(type: ReferenceRealTimeDatabaseType) -> Completable
    func executeGetDirection(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, googleApiKey: String) -> Observable<GMSPolyline>
}

final class LocationUseCaseImpl {
    
    private let locationRepository: LocationRepository
    
    init(locationRepository: LocationRepository) {
        self.locationRepository = locationRepository
    }
    
}

extension LocationUseCaseImpl: LocationUseCase {
    
    func executeRequestPremission() {
        locationRepository.requestPremission()
    }
    
    func executeGetStatusPermission() -> CLAuthorizationStatus {
        locationRepository.getStatusPermission()
    }
    
    func executeSetLocationDelegate(_ vc: UIViewController) {
        locationRepository.setLocationDelegate(vc)
    }
    
    func executeStartUpdatingLocation() {
        locationRepository.startUpdatingLocation()
    }
    
    func executeStopUpdatingLocation() {
        locationRepository.stopUpdatingLocation()
    }
    
    func executeSetValue<T>(modelValue: T, type: ReferenceRealTimeDatabaseType) -> RxSwift.Completable where T : Decodable, T : Encodable {
        locationRepository.setValue(modelValue: modelValue, type: type)
    }
    
    func executeObserverValue<T>(type: ReferenceRealTimeDatabaseType) -> RxSwift.Single<T?> where T : Decodable, T : Encodable {
        locationRepository.observerValue(type: type)
    }
    
    func executeDeleteValue(type: ReferenceRealTimeDatabaseType) -> RxSwift.Completable {
        locationRepository.deleteValue(type: type)
    }
    
    func executeGetDirection(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, googleApiKey: String) -> Observable<GMSPolyline> {
        self.locationRepository.getDirectionMaps(origin: origin, destination: destination, googleAPIkey: googleApiKey)
    }
}
