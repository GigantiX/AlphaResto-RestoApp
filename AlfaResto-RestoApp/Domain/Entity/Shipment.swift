//
//  Shipment.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 21/06/24.
//

import UIKit

enum StatusDelivery: String, Codable {
    case onProcess = "On Process"
    case onDelivery = "On Delivery"
    case delivered = "Delivered"
    case cancelled = "Cancelled"
    
    func getStatus() -> String {
        switch self {
        case .onProcess:
            "On Process"
        case .onDelivery:
            "On Delivery"
        case .delivered:
            "Delivered"
        case .cancelled:
            "Cancelled"
        }
    }
    
    func getColor() -> UIColor {
        switch self {
        case.onProcess:
            return .main
        case .onDelivery:
            return .subMain
        case .delivered:
            return .mainGreen
        case .cancelled:
            return .mainRed
        }
    }
    
    func getIconImage() -> UIImage {
        switch self {
        case .onProcess:
            UIImage(systemName: "takeoutbag.and.cup.and.straw") ?? UIImage()
        case .onDelivery:
            UIImage(systemName: "truck.box.badge.clock") ?? UIImage()
        case .delivered:
            UIImage(systemName: "text.badge.checkmark") ?? UIImage()
        case .cancelled:
            UIImage(systemName: "text.badge.xmark") ?? UIImage()
        }
    }
}

struct Shipment: Codable {
    
    let id: String?
    let orderID: String?
    let statusDelivery: StatusDelivery?
    let isAlreadyNotifyWhen50m: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case orderID = "order_id"
        case statusDelivery = "status_delivery"
        case isAlreadyNotifyWhen50m = "is_already_notify_when_50_m"
    }
}

extension Shipment {
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.orderID = try container.decodeIfPresent(String.self, forKey: .orderID)
        self.statusDelivery = try container.decodeIfPresent(StatusDelivery.self, forKey: .statusDelivery)
        self.isAlreadyNotifyWhen50m = try container.decodeIfPresent(Bool.self, forKey: .isAlreadyNotifyWhen50m)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.id, forKey: .id)
        try container.encodeIfPresent(self.orderID, forKey: .orderID)
        try container.encodeIfPresent(self.statusDelivery, forKey: .statusDelivery)
        try container.encodeIfPresent(self.isAlreadyNotifyWhen50m, forKey: .isAlreadyNotifyWhen50m)
    }
}
