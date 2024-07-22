//
//  Network.swift
//  AlfaResto-RestoApp
//
//  Created by Axel Ganendra on 03/07/24.
//

import Foundation
import Network
import UIKit

class AccessNetwork {
    static func checkConnection(monitor: NWPathMonitor, view: UIViewController) {
        monitor.pathUpdateHandler = { path in
            if path.status != .satisfied {
                Alert.show(type: .standard(title: "No Internet Connection", msg: "Please enable internet to use this app!"), viewController: view)
            }
        }
        let queue = DispatchQueue(label: "Network Monitor")
        monitor.start(queue: queue)
    }
}
