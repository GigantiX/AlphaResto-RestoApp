//
//  FirebaseStorage.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 19/06/24.
//

import Foundation
import FirebaseStorage

final class FirebaseStorage {
    
    let storage: Storage
    
    init() {
        self.storage = Storage.storage()
    }
    
}
