//
//  AppDIContainer.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 26/06/24.
//

import Foundation

final class AppDIContainer {
    
    lazy var appConfig = AppConfiguration()
    
    // MARK: - Network
    lazy var notifApiDataTransferServices: DataTransferService = {
        let config = ApiDataNetworkConfig(
            baseURL: URL(string: AppConfiguration.notifBaseAPIUrl ?? "") ?? URL(fileURLWithPath: "")
        )
        
        let apiDataNetwork = DefaultNetworkService(config: config)
        return DataTransferServicesImpl(networkService: apiDataNetwork)
    }()
}
