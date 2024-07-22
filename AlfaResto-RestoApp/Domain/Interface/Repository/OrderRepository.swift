//
//  OrderUseCase.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 24/06/24.
//

import Foundation
import RxSwift

protocol OrderRepository {
    func fetchOrderData(orderID: String) -> Single<Order>
    func getAllOrderItemFrom(orderID: String) -> Observable<[OrderItem]?>
    func fetchAllHistoryOrder(isDescending: Bool) -> Single<[Order]>
    func fetchAllOngoingOrder(isDescending: Bool) -> Single<[Order]>
    func getOnGoingOrderCount() -> Observable<Int?>
    func getUserToken(userID: String) -> Observable<String?>
}
