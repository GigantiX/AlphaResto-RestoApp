//
//  Constant.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 12/06/24.
//

import UIKit

final class Constant {
    // Image
    static let showPasswordEnableImage = UIImage(systemName: "eye")
    static let showPasswordDisableImage = UIImage(systemName: "eye.slash")
    static let alfaRestoLogoImage = UIImage(named: "AlfaRestoLogo")
    static let loading = "LoadingAnimation"
    
    // Error Message
    static let allFieldMustBeFilled = "All Field must be filled!"
    static let invalidData = "Email/Password is not valid"
    
    // TabBar
    static let profile = "Profile"
    static let menu = "Menu"
    static let order = "Order"
    
    static let profileTabBarImage = UIImage(systemName: "house")
    static let menuTabBarImage = UIImage(systemName: "list.bullet.rectangle.portrait")
    static let orderTabBarImage = UIImage(systemName: "cart")
    
    static let selectedProfileTabBarImage = UIImage(systemName: "house.fill")
    static let selectedMenuTabBarImage = UIImage(systemName: "list.bullet.rectangle.portrait.fill")
    static let selectedOrderTabBarImage = UIImage(systemName: "cart.fill")
    
    // Words
    static let menus = "menus"
    static let users = "users"
    static let resto = "restaurants"
    static let orders = "orders"
    static let orderItems = "order_items"
    static let googleAPIKey = "GoogleAPIKey"
    static let shipments = "shipments"
    static let chats = "chats"
    static let DELIVERED = "Delivered"
    
    static let defaultMenuDescription = "(Optional) Enter Description..."
    static let notifBaseAPIUrl = "NotifBaseAPIUrl"
    static let dirMapsBaseAPIUrl = "DirectionMapsBaseAPIUrl"
    
    // Deep Link
    static let trackOrderDeepLinkUrlAndroid = "example://customers/trackorder/"
    static let orderDetailDeepLinkUrlAndroid = "example://customers/orderDetail/"
    static let chatDeepLinkUrlAndroid = "example://customers/chat/"
}

