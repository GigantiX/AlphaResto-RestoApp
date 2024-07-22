//
//  OrderRepositoryImpl.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 24/06/24.
//

import Foundation
import RxSwift

enum FetchOrderType {
    case onGoing
    case history
}

final class OrderRepositoryImpl {
    
    private let disposeBag = DisposeBag()
    private let firestoreServices: FirestoreServices
    private let firebaseRealtimeServices: FirebaseDatabaseServices
    
    init(firestoreServices: FirestoreServices, firebaseRealtimeServices: FirebaseDatabaseServices) {
        self.firestoreServices = firestoreServices
        self.firebaseRealtimeServices = firebaseRealtimeServices
    }
}

extension OrderRepositoryImpl: OrderRepository {
    
    func getUserToken(userID: String) -> Observable<String?> {
        return Observable.create { observer in
            _ = FirestoreReferences.getUserDocumentReferences(userID: userID)
                .addSnapshotListener { snapshot, error in
                    if let error = error {
                        observer.onError(error)
                        return
                    }
                    
                    do {
                        if let snapshot {
                            let userToken = try snapshot.data(as: UserToken.self)
                            observer.onNext(userToken.token)
                            return
                        }
                        observer.onNext(nil)
                        
                    } catch {
                        observer.onError(error)
                    }
                }
            
            return Disposables.create()
        }
    }
    
    func fetchOrderData(orderID: String) -> Single<Order> {
        return Single.create { single in
            Task {
                do {
                    let reference = FirestoreReferences.getOrderDocumentReferences(orderID: orderID)
                    let result = try await reference.getDocument(as: Order.self)
                    single(.success(result))
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    func getAllOrderItemFrom(orderID: String) -> Observable<[OrderItem]?> {
        return Observable.create { observer in
            Task {
                do {
                    let firestoreOrderItemReferences = FirestoreReferences.getOrderItemCollectionReferences(orderID: orderID)
                    let results = try await firestoreOrderItemReferences.getAllDocuments(as: OrderItem.self)
                    observer.onNext(results)
                    observer.onCompleted()
                } catch {
                    observer.onError(AppError.errorFetchData)
                }
            }
            
            return Disposables.create()
        }
    }
    
    func fetchAllOngoingOrder(isDescending: Bool) -> Single<[Order]> {
        fetchAllOrder(isDescending: isDescending, type: .onGoing)
    }
    
    func fetchAllHistoryOrder(isDescending: Bool) -> Single<[Order]> {
        fetchAllOrder(isDescending: isDescending, type: .history)
    }
    
    func getOnGoingOrderCount() -> Observable<Int?> {
        return Observable.create { observer in
            _ = FirestoreReferences.getShipmentCollectionReferences()
                .whereField(Shipment.CodingKeys.statusDelivery.rawValue, in: [StatusDelivery.onProcess.rawValue, StatusDelivery.onDelivery.rawValue])
                .addSnapshotListener { snapshot, error in
                    if let error {
                        observer.onError(error)
                        return
                    }
                    
                    if let snapshot {
                        observer.onNext(snapshot.documents.count)
                    }
                }
            return Disposables.create()
        }
    }
}

private extension OrderRepositoryImpl {
    func fetchAllOrder(isDescending: Bool, type: FetchOrderType) -> Single<[Order]> {
        return Single.create { single in
            let reference = FirestoreReferences.getOrderCollectionReferences().order(by: "order_date", descending: isDescending)
            
            reference.getDocuments { (result, error) in
                if let error {
                    single(.failure(error))
                    return
                }
                
                guard let docs = result?.documents else {
                    single(.success([]))
                    return
                }
                
                let observeOrder = docs.map { document -> Single<Order?> in
                    let orderID = document.documentID
                    
                    return Single.zip(self.fetchOrderData(orderID: orderID), self.fetchOrderItems(orderID: orderID), self.checkOrderStatus(orderID: orderID)) { orderDetail, orderItems, status in
                        if type == .onGoing {
                            guard status != StatusDelivery.delivered.rawValue && status != StatusDelivery.cancelled.rawValue else {
                                return nil
                            }
                        }
                        if type == .history {
                            guard status == StatusDelivery.delivered.rawValue || status == StatusDelivery.cancelled.rawValue else {
                                return nil
                            }
                        }
                        
                        var order = orderDetail
                        order.orderItems = orderItems
                        return order
                    }
                }
                
                Single.zip(observeOrder).map({ items in
                    items.compactMap { $0 }
                }).subscribe(onSuccess: { order in
                    single(.success(order))
                }, onFailure: { error in
                    single(.failure(error))
                }).disposed(by: self.disposeBag)
            }
            
            return Disposables.create()
        }
    }
    
    func fetchOrderItems(orderID: String) -> Single<[OrderItem]> {
        return Single.create { single in
            let reference = FirestoreReferences.getOrderItemCollectionReferences(orderID: orderID)
            reference.getDocuments { (result, error) in
                if let error {
                    single(.failure(error))
                } else {
                    guard let result else {
                        single(.failure(NSError(domain: "Document not exist", code: -2)))
                        return
                    }
                    var items: [OrderItem] = []
                    
                    for document in result.documents {
                        do {
                            let item = try document.data(as: OrderItem.self)
                            items.append(item)
                        } catch {
                            single(.failure(error))
                            return
                        }
                    }
                    single(.success(items))
                }
            }
            return Disposables.create()
        }
    }
    
    func checkOrderStatus(orderID: String) -> Single<String?> {
        return Single.create { single in
            let reference = FirestoreReferences.getShipmentCollectionReferences()
            
            reference.whereField("order_id", isEqualTo: orderID).getDocuments { (result, error) in
                if let error {
                    single(.failure(error))
                } else {
                    guard let documents = result?.documents, !documents.isEmpty else {
                        single(.success(nil))
                        return
                    }
                    
                    let document = documents.first
                    if let statusDelivery = document?.data()["status_delivery"] as? String {
                        single(.success(statusDelivery))
                    } else {
                        single(.success(nil))
                    }
                }
            }
            return Disposables.create()
        }
    }
}
