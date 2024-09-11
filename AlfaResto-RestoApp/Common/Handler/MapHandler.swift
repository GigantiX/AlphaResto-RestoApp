//
//  MapHandler.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 01/07/24.
//

import Foundation
import GoogleMaps

final class MapHandler {
    
    static let shared = MapHandler()
    private var mapView: GMSMapView?
    
    private init() { }

}

extension MapHandler {
    func getMapView(options: GMSMapViewOptions) -> GMSMapView {
        if mapView == nil {
            mapView = GMSMapView.init(options: options)
        }
        return mapView ?? GMSMapView()
    }
}
