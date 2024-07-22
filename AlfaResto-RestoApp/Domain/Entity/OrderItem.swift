//
//  OrderItem.swift
//  AlfaResto-RestoApp
//
//  Created by Axel Ganendra on 24/06/24.
//

import Foundation

struct OrderItem: Codable {
    let menuName: String?
    let menuPrice: Int?
    let id: String?
    let quantity: Int?
    
    enum CodingKeys: String, CodingKey {
        case menuName = "menu_name"
        case menuPrice = "menu_price"
        case id = "order_item_id"
        case quantity
    }
}

extension OrderItem {
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.menuName = try container.decodeIfPresent(String.self, forKey: .menuName)
        self.menuPrice = try container.decodeIfPresent(Int.self, forKey: .menuPrice)
        self.quantity = try container.decodeIfPresent(Int.self, forKey: .quantity)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.id, forKey: .id)
        try container.encodeIfPresent(self.menuName, forKey: .menuName)
        try container.encodeIfPresent(self.menuPrice, forKey: .menuPrice)
        try container.encodeIfPresent(self.quantity, forKey: .quantity)
    }
}
