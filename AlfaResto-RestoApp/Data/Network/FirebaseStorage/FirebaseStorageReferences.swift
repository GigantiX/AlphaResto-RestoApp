//
//  FirebaseStorageReferences.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 19/06/24.
//

import Foundation
import FirebaseStorage

enum ReferenceStorageType: String {
    case restoProfile = "resto_profile"
    case menu = "menus"
}

final class FirebaseStorageReferences {
    
    static let shared = FirebaseStorageReferences()
    
    private let storage = FirebaseStorage().storage
    
    private init() { }

    static func setReferenceStorage(path: String, type: ReferenceStorageType) -> StorageReference {
        shared.storage.reference().child(type.rawValue).child(path)
    }
}
