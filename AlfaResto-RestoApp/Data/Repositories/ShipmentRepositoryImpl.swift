//
//  ShipmentRepositoryImpl.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 21/06/24.
//

import Foundation
import RxSwift

final class ShipmentRepositoryImpl {
    
    private let firestoreServices: FirestoreServices
    
    init(firestoreServices: FirestoreServices) {
        self.firestoreServices = firestoreServices
    }
    
}

extension ShipmentRepositoryImpl: ShipmentRepository {
    func manageShipment(orderID: String, status: String) -> RxSwift.Completable {
        return Completable.create { [weak self] completable in
            guard let self else { return Disposables.create() }
            Task {
                do {
                    let isDocumentExists = try await self.isShipmentDocumentExists(with: orderID)
                    
                    if isDocumentExists {
                        try await self.updateStatus(orderID: orderID, status: status)
                    } else {
                        try self.createShipmentToFirestore(orderID: orderID)
                    }
                    
                    completable(.completed)
                } catch {
                    completable(.error(AppError.unexpectedError))
                }
                return Disposables.create()
            }
            return Disposables.create()
        }
    }
    
    func getShipmentDetailWith(orderID: String) -> Observable<Shipment?> {
        return Observable.create { observer in
            Task {
                do {
                    let shipmentDocumentReference = try await FirestoreReferences.getShipmentDocumentReferencesBy(orderID: orderID)
                    let result = try await shipmentDocumentReference?.getDocument(as: Shipment.self)
                    observer.onNext(result)
                    observer.onCompleted()
                } catch {
                    observer.onError(AppError.unexpectedError)
                }
            }
            return Disposables.create()
        }
    }
    
    func checkIsAlreadyNotifyWhen50M(orderID: String) -> Single<Bool> {
        return Single.create { single in
            Task {
                do {
                    let shipmentDocumentReference = try await FirestoreReferences.getShipmentDocumentReferencesBy(orderID: orderID)
                    let result = try await shipmentDocumentReference?.getDocument(as: Shipment.self)
                    single(.success(result?.isAlreadyNotifyWhen50m ?? true))
                } catch {
                    single(.failure(AppError.unexpectedError))
                }
            }
            return Disposables.create()
        }
    }
    
    func updateIsAlreadyNotifyWhen50m(orderID: String, isNotify: Bool) -> Completable {
        return Completable.create { completable in
            Task {
                let shipmentDocument = try await FirestoreReferences.getShipmentDocumentReferencesBy(orderID: orderID)
                
                let updatedData: [String: Any] = [
                    Shipment.CodingKeys.isAlreadyNotifyWhen50m.rawValue: isNotify
                ]
                try await shipmentDocument?.updateData(updatedData)
                completable(.completed)
            }
            return Disposables.create()
        }
    }
}

private extension ShipmentRepositoryImpl {
    func createShipmentToFirestore(orderID: String) throws {
        let (newDocument, id) = self.firestoreServices.generateDocumentID(type: .shipment)
        let shipment = Shipment(id: id, orderID: orderID, statusDelivery: .onDelivery, isAlreadyNotifyWhen50m: false)
        try newDocument.setData(from: shipment, merge: false)
    }

    func updateStatus(orderID: String, status: String) async throws {
        let shipmentDocument = try await FirestoreReferences.getShipmentDocumentReferencesBy(orderID: orderID)
        
        let updatedData: [String: Any] = [
            Shipment.CodingKeys.statusDelivery.rawValue: status
        ]
        try await shipmentDocument?.updateData(updatedData)
    }
    
    func isShipmentDocumentExists(with orderID: String) async throws -> Bool {
        let snapshot = try await FirestoreReferences.getShipmentCollectionReferences()
            .whereField(Shipment.CodingKeys.orderID.rawValue, isEqualTo: orderID)
            .getDocuments()
        return ((snapshot.documents.first?.exists) != nil)
    }
}
