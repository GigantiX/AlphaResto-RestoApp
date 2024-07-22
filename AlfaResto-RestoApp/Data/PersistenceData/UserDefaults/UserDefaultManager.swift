//
//  UserDefaultManager.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 14/06/24.
//

import Foundation

final class UserDefaultManager {
    
    private enum Keys: String {
        case restoID
        case deviceToken
    }
    
    static var restoID: String? {
        get { UserDefaults.standard.string(forKey: Keys.restoID.rawValue) }
        set (newValue) { UserDefaults.standard.setValue(newValue, forKey: Keys.restoID.rawValue) }
    }
    
    static var deviceToken: String? {
        get { UserDefaults.standard.string(forKey: Keys.deviceToken.rawValue) }
        set (newValue) { UserDefaults.standard.setValue(newValue, forKey: Keys.deviceToken.rawValue) }
    }
}

