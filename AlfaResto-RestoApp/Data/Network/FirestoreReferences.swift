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
}
