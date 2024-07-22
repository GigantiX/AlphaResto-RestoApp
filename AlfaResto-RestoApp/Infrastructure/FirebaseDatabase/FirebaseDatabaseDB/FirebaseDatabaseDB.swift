//
//  FirebaseDatabaseStorage.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 26/06/24.
//

import Foundation
import FirebaseDatabase

final class FirebaseDatabaseDB {
    
    let firebaseDatabaseDB: Database
    
    init() {
        self.firebaseDatabaseDB = Database.database()
    }
    
}
