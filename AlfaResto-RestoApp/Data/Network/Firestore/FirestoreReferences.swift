//
//  FirestoreReferences.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 18/06/24.
//

import Foundation
import FirebaseFirestore

final class FirestoreReferences {
    
    static let shared = FirestoreReferences()
    
    private let firestoreDB = FirestoreDB()
    
    // MARK: - User
    static func getUserCollectionReferences() -> CollectionReference {
        shared.firestoreDB.db.collection(Constant.users)
    }
    
    static func getUserDocumentReferences(userID: String) -> DocumentReference {
        getUserCollectionReferences().document(userID)
    }
        
    // MARK: - Menu
    static func getMenuCollectionReferences() -> CollectionReference {
        shared.firestoreDB.db.collection(Constant.menus)
    }
    
    static func getMenuDocumentReferences(menuID: String) -> DocumentReference {
        getMenuCollectionReferences().document(menuID)
    }
    
    // MARK: - Resto
    static func getRestoCollectionReferences() -> CollectionReference {
        shared.firestoreDB.db.collection(Constant.resto)
    }
    
    static func getRestoDocumentReferences(restoID: String) -> DocumentReference {
        getRestoCollectionReferences().document(restoID)
    }
        
    // MARK: - Order
    static func getOrderCollectionReferences() -> CollectionReference {
        shared.firestoreDB.db.collection(Constant.orders)
    }
    
    static func getOrderDocumentReferences(orderID: String) -> DocumentReference {
        getOrderCollectionReferences().document(orderID)
    }
    
    // MARK: - Order Item
    static func getOrderItemCollectionReferences(orderID: String) -> CollectionReference {
        getOrderDocumentReferences(orderID: orderID).collection(Constant.orderItems)
    }
    
    static func getOrderItemDocumentReferences(orderID: String, orderItemID: String) -> DocumentReference {
        getOrderItemCollectionReferences(orderID: orderID).document(orderItemID)
    }
    
    // MARK: - Shipment
    static func getShipmentCollectionReferences() -> CollectionReference {
        shared.firestoreDB.db.collection(Constant.shipments)
    }
    
    static func getShipmentDocumentReferences(shipmentID: String) -> DocumentReference {
        getShipmentCollectionReferences().document(shipmentID)
    }
    
    static func getShipmentDocumentReferencesBy(orderID: String) async throws -> DocumentReference? {
        let snapshot = try await getShipmentCollectionReferences()
            .whereField(Shipment.CodingKeys.orderID.rawValue, isEqualTo: orderID)
            .getDocuments()
        if let document = snapshot.documents.first {
            return document.reference
        }
        return nil
    }
    
    // MARK: - Message
    static func getChatsCollectionReferences(orderID: String) -> CollectionReference {
        getOrderDocumentReferences(orderID: orderID).collection(Constant.chats)
    }
}
