//
//  FirestoreServices.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 17/06/24.
//

import Foundation
import FirebaseFirestore

enum CollectionType {
    case menu
    case shipment
}

protocol FirestoreServices {
    var encoder: Firestore.Encoder { get }
    var decoder: Firestore.Decoder { get }
    func generateDocumentID(type: CollectionType) -> (DocumentReference, String)
}

final class FirestoreServicesImpl {
    
    var encoder: Firestore.Encoder = {
        Firestore.Encoder()
    }()
    
    var decoder: Firestore.Decoder = {
        Firestore.Decoder()
    }()
     
    init() { }
}

extension FirestoreServicesImpl: FirestoreServices {
    func generateDocumentID(type: CollectionType) -> (DocumentReference, String) {
        switch type {
        case .menu:
            let menuDocument = FirestoreReferences.getMenuCollectionReferences().document()
            return (menuDocument, menuDocument.documentID)
        case .shipment:
            let shipmentDocument = FirestoreReferences.getShipmentCollectionReferences().document()
            return (shipmentDocument, shipmentDocument.documentID)
        }
    }
}
