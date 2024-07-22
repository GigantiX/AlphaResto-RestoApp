//
//  FirestoreDB.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 17/06/24.
//

import Foundation
import FirebaseFirestore

final class FirestoreDB {
    
    let db: Firestore
    
    init() {
        self.db = Firestore.firestore()
    }
}
