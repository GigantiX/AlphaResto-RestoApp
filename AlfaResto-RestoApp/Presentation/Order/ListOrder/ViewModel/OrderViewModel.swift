//
//  OrderViewModel.swift
//  AlfaResto-RestoApp
//
//  Created by Axel Ganendra on 23/06/24.
//

import Foundation
import RxSwift

enum FetchResult {
    case success
    case failure(Error)
}

protocol OrderViewModelInput {
    func fetchOngoingOrder()
    func fetchHistoryOrder()
}

protocol OrderViewModelOutput {
    var data: [Order] { get set }
    var shipmentData: [String : Shipment?] { get set }
    var disposeBag: DisposeBag { get }
    var descending: Bool { get set }
    var onGoingOrderCount: Int? { get set }
    var observeFetch: PublishSubject<FetchResult> { get }
    var observeHistory: PublishSubject<FetchResult> { get }
    var observeShipment: PublishSubject<FetchResult> { get }
}

protocol OrderViewModel: OrderViewModelInput, OrderViewModelOutput { }

final class OrderViewModelImpl: OrderViewModel {
    // MARK: - UseCase
    private let orderUseCase: OrderUseCase
    private let shipmentUseCase: ShipmentUseCase
    
    // MARK: - Output
    var data: [Order] = []
    var descending: Bool = true
    var onGoingOrderCount: Int?
    var shipmentData: [String : Shipment?] = [:]
    var disposeBag = DisposeBag()
    var getOnGoingOrderCountObservable = PublishSubject<FetchResult>()
    var observeFetch: PublishSubject<FetchResult> = PublishSubject()
    var observeHistory: PublishSubject<FetchResult> = PublishSubject()
    var observeShipment: PublishSubject<FetchResult> = PublishSubject()
    
    init(orderUseCase: OrderUseCase, shipmentUseCase: ShipmentUseCase) {
        self.orderUseCase = orderUseCase
        self.shipmentUseCase = shipmentUseCase
    }
}

extension OrderViewModelImpl {
    func fetchOngoingOrder() {
        emptyData()
        orderUseCase.executeFetchOngoingOrder(isDescending: descending).subscribe(onSuccess: { result in
            self.data = result
            self.refreshWhenEmpty(data: result)
            self.fetchShipment(order: result)
            self.observeFetch.onNext(.success)
        }, onFailure: { error in
            self.observeFetch.onError(error)
            debugPrint(error)
        }).disposed(by: disposeBag)
    }
    
    func fetchHistoryOrder() {
        emptyData()
        orderUseCase.executeFetchHistoryOrder(isDescending: descending).subscribe(onSuccess: { result in
            self.data = result
            self.refreshWhenEmpty(data: result)
            self.fetchShipment(order: result)
            self.observeHistory.onNext(.success)
        }, onFailure: { error in
            self.observeHistory.onError(error)
            debugPrint(error)
        }).disposed(by: disposeBag)
    }
    
    func fetchShipment(order: [Order]) {
        let dataShipment = order.map { order in
            shipmentUseCase.executeGetShipmentDetailWith(orderID: order.id ?? "").map { (order.id, $0) }
        }
        Observable.zip(dataShipment).subscribe(onNext: { shipments in
            for (orderId, shipment) in shipments {
                self.shipmentData[orderId ?? ""] = shipment
            }
            self.observeShipment.onNext(.success)
        }, onError: { error in
            self.observeShipment.onError(error)
        }).disposed(by: disposeBag)
    }

    func emptyData() {
        data.removeAll()
        shipmentData.removeAll()
    }
    
    func refreshWhenEmpty(data: [Order]) {
        if data.isEmpty {
            self.observeShipment.onNext(.success)
        }
    }
}
