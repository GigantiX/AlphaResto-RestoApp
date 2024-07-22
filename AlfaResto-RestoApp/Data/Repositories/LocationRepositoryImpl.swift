//
//  LocationRepositoryImpl.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 26/06/24.
//

import UIKit
import CoreLocation
import RxSwift
import GoogleMaps

final class LocationRepositoryImpl {
    
    var disposeBag = DisposeBag()
    
    private let locationServices: LocationServices
    private let firebaseDatabaseServices: FirebaseDatabaseServices
    private let dataTransferServices: DataTransferService
    
    init(locationServices: LocationServices,
         firebaseDatabaseServices: FirebaseDatabaseServices,
         dataTransferServices: DataTransferService
    ) {
        self.locationServices = locationServices
        self.firebaseDatabaseServices = firebaseDatabaseServices
        self.dataTransferServices = dataTransferServices
    }
    
}

extension LocationRepositoryImpl: LocationRepository {
    func requestPremission() {
        locationServices.requestPremission()
    }
    
    func getStatusPermission() -> CLAuthorizationStatus {
        locationServices.getStatusPermission()
    }
    
    func setLocationDelegate(_ vc: UIViewController) {
        locationServices.setLocationDelegate(vc)
    }
    
    func startUpdatingLocation() {
        locationServices.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationServices.stopUpdatingLocation()
    }
    
    func setValue<T: Codable>(modelValue: T, type: ReferenceRealTimeDatabaseType) -> Completable {
        firebaseDatabaseServices.setValue(modelValue: modelValue, type: type)
    }
    
    func observerValue<T: Codable>(type: ReferenceRealTimeDatabaseType) -> Single<T?> {
        firebaseDatabaseServices.observeValue(type: type)
    }
    
    func deleteValue(type: ReferenceRealTimeDatabaseType) -> Completable {
        firebaseDatabaseServices.deleteValue(type: type)
    }
    
    func getDirectionMaps(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, googleAPIkey: String) -> Observable<GMSPolyline> {
        return Observable.create { [weak self] observer in
            guard let self else { return Disposables.create() }
            
            let endpoint = APIEndpoints.getDirectionMaps(origin: origin, destination: destination, key: googleAPIkey)
            
            self.dataTransferServices.requestDirectionMaps(with: endpoint)
                .subscribe { event in
                    switch event {
                    case .next(let direction):
                        guard let route = direction.routes?.first
                        else { return }
                        let polyline = route.overviewPolyline?.points
                        
                        let path = GMSPath(fromEncodedPath: polyline ?? "")
                        
                        let gmPolyline = GMSPolyline(path: path)
                        gmPolyline.strokeColor = .main
                        gmPolyline.strokeWidth = 3.0
                        observer.onNext(gmPolyline)
                    case .error(let error):
                        observer.onError(error)
                    default:
                        break
                    }
                }
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}
