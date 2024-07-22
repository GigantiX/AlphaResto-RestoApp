//
//  Encodable+extensions.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 27/06/24.
//

import Foundation

extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        return jsonData as? [String : Any]
    }
}
