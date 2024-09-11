//
//  ShipmentUseCase.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 24/06/24.
//

import Foundation
import RxSwift

protocol ShipmentUseCase {
    func executeManageShipment(orderID: String, status: String) -> Completable
    func executeGetShipmentDetailWith(orderID: String) -> Observable<Shipment?>
    func executeCheckIsAlreadyNotifyWhen50M(orderID: String) -> Single<Bool>
    func executeUpdateIsAlreadyNotifyWhen50m(orderID: String, isNotify: Bool) -> Completable
}

final class ShipmentUseCaseImpl {
    
    private let shipmentRepository: ShipmentRepository
    
    init(shipmentRepository: ShipmentRepository) {
        self.shipmentRepository = shipmentRepository
    }
    
}

extension ShipmentUseCaseImpl: ShipmentUseCase {
    func executeManageShipment(orderID: String, status: String) -> RxSwift.Completable {
        shipmentRepository.manageShipment(orderID: orderID, status: status)
    }
    
    func executeGetShipmentDetailWith(orderID: String) -> Observable<Shipment?> {
        shipmentRepository.getShipmentDetailWith(orderID: orderID)
    }
    
    func executeCheckIsAlreadyNotifyWhen50M(orderID: String) -> Single<Bool> {
        shipmentRepository.checkIsAlreadyNotifyWhen50M(orderID: orderID)
    }
    
    func executeUpdateIsAlreadyNotifyWhen50m(orderID: String, isNotify: Bool) -> Completable {
        shipmentRepository.updateIsAlreadyNotifyWhen50m(orderID: orderID, isNotify: isNotify)
    }
}
