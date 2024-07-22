//
//  Notification.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 26/06/24.
//

import Foundation

struct NotificationRequest: Codable {
    let tokenNotification: String?
    let title: String?
    let body: String?
    let link: String?
    
    enum CodingKeys: String, CodingKey {
        case title, body, link
        case tokenNotification = "to"
    }
}

extension NotificationRequest {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.tokenNotification = try container.decodeIfPresent(String.self, forKey: .tokenNotification)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.body = try container.decodeIfPresent(String.self, forKey: .body)
        self.link = try container.decodeIfPresent(String.self, forKey: .link)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.tokenNotification, forKey: .tokenNotification)
        try container.encodeIfPresent(self.title, forKey: .title)
        try container.encodeIfPresent(self.body, forKey: .body)
        try container.encodeIfPresent(self.link, forKey: .link)
    }
}
