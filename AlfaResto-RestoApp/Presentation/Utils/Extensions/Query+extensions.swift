//
//  Query+extension.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 14/06/24.
//

import Foundation
import FirebaseFirestore

extension Query {
    func getAllDocuments<T: Decodable>(as type: T.Type) async throws -> [T]? {
        let snapshot = try await self.getDocuments()
        
        return try snapshot.documents.compactMap {
            try $0.data(as: T.self)
        }
    }
}
