//
//  FirebaseDatabaseReferences.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 26/06/24.
//

import Foundation
import FirebaseDatabase

enum ReferenceRealTimeDatabaseType: String {
    case driverLocation = "driver_location"
}

final class FirebaseDatabaseReferences {
    
    static let shared = FirebaseDatabaseReferences()
    
    private let database = FirebaseDatabaseDB().firebaseDatabaseDB
    
    private init() { }   
    
    static func setReferenceRealTimeDatabase(type: ReferenceRealTimeDatabaseType) -> DatabaseReference {
        return shared.database.reference().child(type.rawValue)
    }
}
