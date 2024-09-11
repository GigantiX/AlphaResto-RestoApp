//
//  Order.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 24/06/24.
//

import Foundation
import CoreLocation

struct Order: Codable {
    let id: String?
    let userID: String?
    let userName: String?
    let address: String?
    let orderDate: Date?
    let totalPrice: Int?
    let notes: String?
    let latitude: CLLocationDegrees?
    let longitude: CLLocationDegrees?
    let readStatus: Bool?
    var orderItems: [OrderItem] = []
    
    enum CodingKeys: String, CodingKey {
        case latitude, longitude, notes
        case id = "order_id"
        case userID = "user_id"
        case userName = "user_name"
        case address = "full_address"
        case orderDate = "order_date"
        case totalPrice = "total_price"
        case readStatus = "read_status"
    }
}

extension Order {
    init(id: String, userID: String? = nil, userName: String? = nil, address: String? = nil, orderDate: Date? = nil, totalPrice: Int? = nil, latitude: CLLocationDegrees? = nil, longitude: CLLocationDegrees? = nil, readStatus: Bool? = nil, orderItems: [OrderItem] = [], notes: String? = nil) {
        self.id = id
        self.userID = userID
        self.userName = userName
        self.address = address
        self.orderDate = orderDate
        self.totalPrice = totalPrice
        self.latitude = latitude
        self.longitude = longitude
        self.readStatus = readStatus
        self.orderItems = orderItems
        self.notes = notes
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.latitude = try container.decodeIfPresent(CLLocationDegrees.self, forKey: .latitude)
        self.longitude = try container.decodeIfPresent(CLLocationDegrees.self, forKey: .longitude)
        self.notes = try container.decodeIfPresent(String.self, forKey: .notes)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.userID = try container.decodeIfPresent(String.self, forKey: .userID)
        self.userName = try container.decodeIfPresent(String.self, forKey: .userName)
        self.address = try container.decodeIfPresent(String.self, forKey: .address)
        self.orderDate = try container.decodeIfPresent(Date.self, forKey: .orderDate)
        self.totalPrice = try container.decodeIfPresent(Int.self, forKey: .totalPrice)
        self.readStatus = try container.decodeIfPresent(Bool.self, forKey: .readStatus)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.latitude, forKey: .latitude)
        try container.encodeIfPresent(self.longitude, forKey: .longitude)
        try container.encodeIfPresent(self.notes, forKey: .notes)
        try container.encodeIfPresent(self.id, forKey: .id)
        try container.encodeIfPresent(self.userID, forKey: .userID)
        try container.encodeIfPresent(self.userName, forKey: .userName)
        try container.encodeIfPresent(self.address, forKey: .address)
        try container.encodeIfPresent(self.orderDate, forKey: .orderDate)
        try container.encodeIfPresent(self.totalPrice, forKey: .totalPrice)
        try container.encodeIfPresent(self.readStatus, forKey: .readStatus)
    }
}

