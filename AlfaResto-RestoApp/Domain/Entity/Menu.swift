//
//  Menu.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 18/06/24.
//

import Foundation

struct Menu: Codable {
    let id: String?
    let restoID: String?
    let menuName: String?
    let menuDescription: String?
    let menuPrice: Int?
    let menuImage: String?
    let menuPath: String?
    let dateCreated: Date?
    let stock: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case restoID = "resto_id"
        case menuName = "menu_name"
        case menuDescription = "menu_description"
        case menuPrice = "menu_price"
        case menuImage = "menu_image"
        case menuPath = "menu_path"
        case dateCreated = "date_created"
        case stock = "menu_stock"
    }
}

extension Menu {
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.stock = try container.decodeIfPresent(Int.self, forKey: .stock)
        self.restoID = try container.decodeIfPresent(String.self, forKey: .restoID)
        self.menuName = try container.decodeIfPresent(String.self, forKey: .menuName)
        self.menuDescription = try container.decodeIfPresent(String.self, forKey: .menuDescription)
        self.menuPrice = try container.decodeIfPresent(Int.self, forKey: .menuPrice)
        self.menuImage = try container.decodeIfPresent(String.self, forKey: .menuImage)
        self.menuPath = try container.decodeIfPresent(String.self, forKey: .menuPath)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.id, forKey: .id)
        try container.encodeIfPresent(self.stock, forKey: .stock)
        try container.encodeIfPresent(self.restoID, forKey: .restoID)
        try container.encodeIfPresent(self.menuName, forKey: .menuName)
        try container.encodeIfPresent(self.menuDescription, forKey: .menuDescription)
        try container.encodeIfPresent(self.menuPrice, forKey: .menuPrice)
        try container.encodeIfPresent(self.menuImage, forKey: .menuImage)
        try container.encodeIfPresent(self.menuPath, forKey: .menuPath)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
    }
}
