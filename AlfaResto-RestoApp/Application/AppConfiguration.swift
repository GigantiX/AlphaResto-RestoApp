//
//  AppConfiguration.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 26/06/24.
//

import Foundation

final class AppConfiguration {
    static var googleApiKey: String? = {
        guard let googleApiKey = Bundle.main.object(forInfoDictionaryKey: Constant.googleAPIKey) as? String else {
            return nil
        }
        
        return googleApiKey
    }()

    static var notifBaseAPIUrl: String? = {
        guard let notifBaseApiUrl = Bundle.main.object(forInfoDictionaryKey: Constant.notifBaseAPIUrl) as? String else {
            return nil
        }
        return notifBaseApiUrl
    }()
    
    static var directionMapsBaseAPIUrl: String? = {
        guard let directionMapsBaseApiUrl = Bundle.main.object(forInfoDictionaryKey: Constant.dirMapsBaseAPIUrl) as? String else {
            return nil
        }
        return directionMapsBaseApiUrl
    }()
}
