//
//  ShipmentRepository.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 21/06/24.
//

import Foundation
import RxSwift

protocol ShipmentRepository {
    func manageShipment(orderID: String, status: String) -> Completable
    func getShipmentDetailWith(orderID: String) -> Observable<Shipment?>
    func checkIsAlreadyNotifyWhen50M(orderID: String) -> Single<Bool>
    func updateIsAlreadyNotifyWhen50m(orderID: String, isNotify: Bool) -> Completable
}
