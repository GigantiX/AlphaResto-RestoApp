//
//  ProfileStoreModel.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 02/07/24.
//

import Foundation

struct ProfileStoreModel: Codable {
    let closingTime: String
    let is24hours: Bool
    let openingTime: String
    let address: String
    let description: String
    let email: String
    let id: String
    let token: String?
    let image: String
    let isTemporaryClose: Bool?
    let phoneNumber: String
    let latitude: CGFloat?
    let longitude: CGFloat?
    
    enum CodingKeys: String, CodingKey {
        case token, latitude, longitude
        case closingTime = "closing_time"
        case isTemporaryClose = "is_temporary_close"
        case is24hours = "is_open_24_hour"
        case openingTime = "opening_time"
        case address = "resto_address"
        case description = "resto_description"
        case email = "resto_email"
        case id = "resto_id"
        case image = "resto_image"
        case phoneNumber = "resto_no_telp"
    }
}

extension ProfileStoreModel {
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.closingTime = try container.decode(String.self, forKey: .closingTime)
        self.is24hours = try container.decode(Bool.self, forKey: .is24hours)
        self.openingTime = try container.decode(String.self, forKey: .openingTime)
        self.address = try container.decode(String.self, forKey: .address)
        self.description = try container.decode(String.self, forKey: .description)
        self.email = try container.decode(String.self, forKey: .email)
        self.id = try container.decode(String.self, forKey: .id)
        self.image = try container.decode(String.self, forKey: .image)
        self.phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        self.token = try container.decodeIfPresent(String.self, forKey: .token)
        self.latitude = try container.decodeIfPresent(CGFloat.self, forKey: .latitude)
        self.longitude = try container.decodeIfPresent(CGFloat.self, forKey: .longitude)
        self.isTemporaryClose = try container.decodeIfPresent(Bool.self, forKey: .isTemporaryClose)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.closingTime, forKey: .closingTime)
        try container.encode(self.is24hours, forKey: .is24hours)
        try container.encodeIfPresent(self.openingTime, forKey: .openingTime)
        try container.encodeIfPresent(self.address, forKey: .address)
        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.image, forKey: .image)
        try container.encodeIfPresent(self.phoneNumber, forKey: .phoneNumber)
        try container.encodeIfPresent(self.token, forKey: .token)
        try container.encodeIfPresent(self.latitude, forKey: .latitude)
        try container.encodeIfPresent(self.longitude, forKey: .longitude)
        try container.encodeIfPresent(self.isTemporaryClose, forKey: .isTemporaryClose)
    }
}
