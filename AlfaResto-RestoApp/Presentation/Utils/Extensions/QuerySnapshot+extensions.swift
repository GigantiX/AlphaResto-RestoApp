//
//  QuerySnapshot+extensions.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 16/07/24.
//

import Foundation
import FirebaseFirestore

extension QuerySnapshot {
    func getAllDocuments<T: Decodable>(as type: T.Type) throws -> [T]? {
        return try self.documents.compactMap {
            try $0.data(as: T.self)
        }
    }
}
