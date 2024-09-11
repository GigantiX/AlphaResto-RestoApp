//
//  DirectionResponse.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 30/06/24.
//

import Foundation
import GoogleMaps

struct DirectionsResponse: Codable {
    let routes: [Route]?
    
    enum CodingKeys: CodingKey {
        case routes
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.routes = try container.decodeIfPresent([Route].self, forKey: .routes)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.routes, forKey: .routes)
    }
}

struct Route: Codable {
    let overviewPolyline: Polyline?
    
    enum CodingKeys: String, CodingKey {
        case overviewPolyline = "overview_polyline"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.overviewPolyline = try container.decodeIfPresent(Polyline.self, forKey: .overviewPolyline)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.overviewPolyline, forKey: .overviewPolyline)
    }
}

struct Polyline: Codable {
    let points: String?
    
    enum CodingKeys: CodingKey {
        case points
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.points = try container.decodeIfPresent(String.self, forKey: .points)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.points, forKey: .points)
    }
}

