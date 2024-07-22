//
//  APIEndpoints.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 26/06/24.
//

import Foundation
import RxSwift
import CoreLocation
import GoogleMaps

struct APIEndpoints {
    static func postNotification(tokenNotification: String, title: String, body: String, link: String?) -> Endpoint<Completable> {
        let parameter = NotificationRequest(tokenNotification: tokenNotification, title: title, body: body, link: link)
        return Endpoint(path: "send", method: .post, bodyParametersEncodable: parameter)
    }
    
    static func getDirectionMaps(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, key: String) -> Endpoint<GMSPolyline>{
        let parameter: [String: Any] = [
           "origin": "\(origin.latitude),\(origin.longitude)",
           "destination": "\(destination.latitude),\(destination.longitude)",
           "key": key,
           "mode": "cycling"
        ]
        return Endpoint(path: "https://maps.googleapis.com/maps/api/directions/json", isFullPath: true, method: .get, queryParameters: parameter)
    }
}
