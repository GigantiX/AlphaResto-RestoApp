//
//  OrderUseCase.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 24/06/24.
//

import Foundation
import RxSwift

protocol OrderUseCase {
    func executeGetOrderDetail(orderID: String) -> Single<Order>
    func executeAllOrderItemFrom(orderID: String) -> Observable<[OrderItem]?>
    func executeFetchOngoingOrder(isDescending: Bool) -> Single<[Order]>
    func executeFetchHistoryOrder(isDescending: Bool) -> Single<[Order]>
    func executeGetOnGoingOrderCount() -> Observable<Int?>
    func executeGetUserToken(userID: String) -> Observable<String?> 
    func executeUpdateChatStatus(orderID: String) -> Completable
    func executeUpdateTotalRevenue(restoID: String, amount: Int) -> Completable
}

final class OrderUseCaseImpl {
    
    private let orderRepository: OrderRepository
    
    init(orderRepository: OrderRepository) {
        self.orderRepository = orderRepository
    }
    
}

extension OrderUseCaseImpl: OrderUseCase {
    func executeUpdateChatStatus(orderID: String) -> RxSwift.Completable {
        orderRepository.updateChatStatus(orderID: orderID)
    }
    
    func executeGetOnGoingOrderCount() -> RxSwift.Observable<Int?> {
        orderRepository.getOnGoingOrderCount()
    }
    
    func executeAllOrderItemFrom(orderID: String) -> RxSwift.Observable<[OrderItem]?> {
        orderRepository.getAllOrderItemFrom(orderID: orderID)
    }
    
    func executeFetchOngoingOrder(isDescending: Bool) -> RxSwift.Single<[Order]> {
        orderRepository.fetchAllOngoingOrder(isDescending: isDescending)
    }
    
    func executeGetOrderDetail(orderID: String) -> Single<Order> {
        orderRepository.fetchOrderData(orderID: orderID)
    }
    
    func executeFetchHistoryOrder(isDescending: Bool) -> Single<[Order]> {
        orderRepository.fetchAllHistoryOrder(isDescending: isDescending)
    }
    
    func executeGetUserToken(userID: String) -> Observable<String?> {
        orderRepository.getUserToken(userID: userID)
    }
    
    func executeUpdateTotalRevenue(restoID: String, amount: Int) -> Completable {
        orderRepository.updateTotalRevenue(restoID: restoID, amount: amount)
    }
}
