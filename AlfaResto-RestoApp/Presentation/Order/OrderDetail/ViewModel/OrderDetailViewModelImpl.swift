//
//  OrderDetailViewModelImpl.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 21/06/24.
//

import UIKit
import RxSwift
import CoreLocation
import GoogleMaps

enum OrderDetailResult {
    case success
    case failure(Error)
}

protocol OrderDetailViewModelInput {
    func getOrderDetail(orderID: String)
    func getAllOrderItemFrom(orderID: String)
    func manageShipment(orderID: String, status: String)
    func getShipmentDetailWith(orderID: String)
    func postNotification(tokenNotification: String, title: String, body: String, link: String?)
    func openGoogleMaps()
    func getStatusPermission() -> CLAuthorizationStatus
    func setLocationDelegate(_ vc: UIViewController)
    func requestPermission()
    func startUpdatingLocation()
    func stopUpdatingLocation()
    func setLocationValueToRealtime(latitude: Double, longitude: Double)
    func deleteLocationValueToRealtime()
    func getRestoCoordinate()
    func getDirectionMaps(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D)
    func checkIsAlreadyNotifyWhen50m()
    func updateIsAlreadyNotifyWhen50m()
    func getUserToken(userID: String)
}

protocol OrderDetailViewModelOutput { 
    var order: Order? { get set }
    var userToken: String? { get set }
    var shipment: Shipment? { get set }
    var orderItems: [OrderItem]? { get set }
    var restaurant: ProfileStoreModel? { get set }
    var coordinate: CLLocationCoordinate2D? { get set }
    var polyline: GMSPolyline? { get set }
    var gmapsView: GMSMapView? { get set }
    var isNotify: Bool? { get set }
    var zoom: Float { get set }
    var isUpdateStatusButtonEnable: Bool? { get set }
    var getOrderDetailObservable: PublishSubject<OrderDetailResult> { get }
    var getListItemObservable: PublishSubject<OrderDetailResult> { get }
    var manageShipmentObservable: PublishSubject<OrderDetailResult> { get }
    var getShipmentDetailObservable: PublishSubject<OrderDetailResult> { get }
    var postNotificationObservable: PublishSubject<OrderDetailResult> { get }
    var setLocationValueToRealtimeObservable: PublishSubject<OrderDetailResult> { get }
    var deleteLocationValueToRealtimeObservable: PublishSubject<OrderDetailResult> { get }
    var checkIsAlreadyNotifyWhen50mObservable: PublishSubject<OrderDetailResult> { get }
    var updateIsAlreadyNotifyWhen50mObservable: PublishSubject<OrderDetailResult> { get }
    var getRestoCoordinateObservable: PublishSubject<OrderDetailResult> { get }
    var getDirectionMapsObservable: PublishSubject<OrderDetailResult> { get }
    var disposeBag: DisposeBag { get }
}

protocol OrderDetailViewModel: OrderDetailViewModelInput, OrderDetailViewModelOutput { }

final class OrderDetailViewModelImpl: OrderDetailViewModel {

    // MARK: - Use Case
    private let shipmentUseCase: ShipmentUseCase
    private let orderUseCase: OrderUseCase
    private let notificationUseCase: NotificationUseCase
    private let locationUseCase: LocationUseCase
    private let restoUseCase: RestoUseCase
    
    // MARK: - Output
    var order: Order?
    var userToken: String?
    var shipment: Shipment?
    var orderItems: [OrderItem]?
    var restaurant: ProfileStoreModel?
    var gmapsView: GMSMapView?
    var isNotify: Bool?
    var zoom: Float = 16.0
    var isUpdateStatusButtonEnable: Bool?
    var getOrderDetailObservable = PublishSubject<OrderDetailResult>()
    var getListItemObservable = PublishSubject<OrderDetailResult>()
    var manageShipmentObservable = PublishSubject<OrderDetailResult>()
    var getShipmentDetailObservable = PublishSubject<OrderDetailResult>()
    var postNotificationObservable = PublishSubject<OrderDetailResult>()
    var setLocationValueToRealtimeObservable = PublishSubject<OrderDetailResult>()
    var deleteLocationValueToRealtimeObservable = PublishSubject<OrderDetailResult>()
    var checkIsAlreadyNotifyWhen50mObservable = PublishSubject<OrderDetailResult>()
    var updateIsAlreadyNotifyWhen50mObservable = PublishSubject<OrderDetailResult>()
    var getRestoCoordinateObservable = PublishSubject<OrderDetailResult>()
    var getDirectionMapsObservable = PublishSubject<OrderDetailResult>()
    var disposeBag = DisposeBag()
    var coordinate: CLLocationCoordinate2D?
    var polyline: GMSPolyline?
    
    init(shipmentUseCase: ShipmentUseCase,
         orderUseCase: OrderUseCase,
         notificationUseCase: NotificationUseCase,
         locationUseCase: LocationUseCase,
         restoUseCase: RestoUseCase
    ) {
        self.shipmentUseCase = shipmentUseCase
        self.orderUseCase = orderUseCase
        self.notificationUseCase = notificationUseCase
        self.locationUseCase = locationUseCase
        self.restoUseCase = restoUseCase
    }
}

extension OrderDetailViewModelImpl {
    func getOrderDetail(orderID: String) {
        orderUseCase.executeGetOrderDetail(orderID: orderID)
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .success(let order):
                    self.order = order
                    self.getUserToken(userID: order.userID ?? "")
                    self.getOrderDetailObservable.onNext(.success)
                case .failure(let error):
                    self.getOrderDetailObservable.onNext(.failure(error))
                }
            }.disposed(by: self.disposeBag)
    }
    
    func getAllOrderItemFrom(orderID: String) {
        orderUseCase.executeAllOrderItemFrom(orderID: orderID)
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .next(let orderItems):
                    self.orderItems = orderItems
                    self.getListItemObservable.onNext(.success)
                case .error(let error):
                    self.getListItemObservable.onNext(.failure(error))
                default:
                    break
                }
            }.disposed(by: self.disposeBag)
    }
    
    func manageShipment(orderID: String, status: String) {
        shipmentUseCase.executeManageShipment(orderID: orderID, status: status)
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .completed:
                    self.manageShipmentObservable.onNext(.success)
                    self.getShipmentDetailWith(orderID: orderID)
                case .error(let error):
                    self.manageShipmentObservable.onNext(.failure(error))
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    func getShipmentDetailWith(orderID: String) {
        shipmentUseCase.executeGetShipmentDetailWith(orderID: orderID)
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .next(let shipment):
                    self.shipment = shipment
                    self.getShipmentDetailObservable.onNext(.success)
                case .error(let error):
                    self.getShipmentDetailObservable.onNext(.failure(error))
                default:
                    break
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    func postNotification(tokenNotification: String, title: String, body: String, link: String?) {
        notificationUseCase.executePostNotification(tokenNotification: tokenNotification, title: title, body: body, link: link)
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .completed:
                    self.postNotificationObservable.onNext(.success)
                case .error(let error):
                    self.postNotificationObservable.onNext(.failure(error))
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    func getUserToken(userID: String) {
        orderUseCase.executeGetUserToken(userID: userID)
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .next(let token):
                    self.userToken = token
                default:
                    break
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    func openGoogleMaps() {
        let appGMapsUrlString = "comgooglemaps://?saddr=\(restaurant?.latitude ?? 0),\(restaurant?.longitude ?? 0)&daddr=\(order?.latitude ?? 0),\(order?.longitude ?? 0)&directionsmode=driving"
        let webGMapsUrlString = "https://www.google.com/maps/dir/?api=1&origin=\(restaurant?.latitude ?? 0),\(restaurant?.longitude ?? 0)&destination=\(order?.latitude ?? 0),\(order?.longitude ?? 0)&travelmode=driving"
        
        if let appUrl = URL(string: appGMapsUrlString) {
            if UIApplication.shared.canOpenURL(appUrl) {
                UIApplication.shared.open(appUrl)
            } else {
                if let webUrl = URL(string: webGMapsUrlString) {
                    UIApplication.shared.open(webUrl)
                }
            }
        }
    }
    
    func getStatusPermission() -> CLAuthorizationStatus {
        locationUseCase.executeGetStatusPermission()
    }
    
    func setLocationDelegate(_ vc: UIViewController) {
        locationUseCase.executeSetLocationDelegate(vc)
    }
    
    func requestPermission() {
        locationUseCase.executeRequestPremission()
    }
    
    func startUpdatingLocation() {
        locationUseCase.executeStartUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationUseCase.executeStopUpdatingLocation()
    }
    
    func setLocationValueToRealtime(latitude: Double, longitude: Double) {
        let locationDriver = LocationDriver(latitude: latitude, longitude: longitude)
        locationUseCase.executeSetValue(modelValue: locationDriver, type: .driverLocation)
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .completed:
                    self.setLocationValueToRealtimeObservable.onNext(.success)
                case .error(let error):
                    self.setLocationValueToRealtimeObservable.onNext(.failure(error))
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    func deleteLocationValueToRealtime() {
        locationUseCase.executeDeleteValue(type: .driverLocation)
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .completed:
                    self.deleteLocationValueToRealtimeObservable.onNext(.success)
                case .error(let error):
                    self.deleteLocationValueToRealtimeObservable.onNext(.failure(error))
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    func getRestoCoordinate() {
        restoUseCase.executeFetchProfile(restoID: UserDefaultManager.restoID ?? "")
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .success(let resto):
                    self.restaurant = resto
                    self.getRestoCoordinateObservable.onNext(.success)
                case .failure(let error):
                    self.getRestoCoordinateObservable.onNext(.failure(error))
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    func getDirectionMaps(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        locationUseCase.executeGetDirection(origin: origin, destination: destination, googleApiKey: AppConfiguration.googleApiKey ?? "")
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .next(let polyline):
                    self.polyline = polyline
                    self.getDirectionMapsObservable.onNext(.success)
                case .error(let error):
                    self.getDirectionMapsObservable.onNext(.failure(error))
                default:
                    break
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    func checkIsAlreadyNotifyWhen50m() {
        self.shipmentUseCase.executeCheckIsAlreadyNotifyWhen50M(orderID: order?.id ?? "")
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .success(let isNotify):
                    self.isNotify = isNotify
                    self.checkIsAlreadyNotifyWhen50mObservable.onNext(.success)
                case .failure(let error):
                    self.checkIsAlreadyNotifyWhen50mObservable.onNext(.failure(error))
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    func updateIsAlreadyNotifyWhen50m() {
        self.shipmentUseCase.executeUpdateIsAlreadyNotifyWhen50m(orderID: order?.id ?? "", isNotify: !(shipment?.isAlreadyNotifyWhen50m ?? false))
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .completed:
                    self.updateIsAlreadyNotifyWhen50mObservable.onNext(.success)
                case .error(let error):
                    self.updateIsAlreadyNotifyWhen50mObservable.onNext(.failure(error))
                }
            }
            .disposed(by: self.disposeBag)
    }
}
