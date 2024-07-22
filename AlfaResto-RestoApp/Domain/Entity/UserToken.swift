//
//  UserToken.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 11/07/24.
//

import Foundation

struct UserToken: Codable {
    let token: String?
    
    enum CodingKeys: String, CodingKey {
        case token
    }
}

extension UserToken {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.token = try container.decodeIfPresent(String.self, forKey: .token)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.token, forKey: .token)
    }
}
