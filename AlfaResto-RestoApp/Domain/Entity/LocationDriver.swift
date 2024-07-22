//
//  LocationDriver.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 28/06/24.
//

import Foundation

struct LocationDriver: Codable {
    let latitude: Double?
    let longitude: Double?
    
    enum CodingKeys: CodingKey {
        case latitude, longitude
    }
}

extension LocationDriver {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.latitude = try container.decodeIfPresent(Double.self, forKey: .latitude)
        self.longitude = try container.decodeIfPresent(Double.self, forKey: .longitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.latitude, forKey: .latitude)
        try container.encodeIfPresent(self.longitude, forKey: .longitude)
    }
}
