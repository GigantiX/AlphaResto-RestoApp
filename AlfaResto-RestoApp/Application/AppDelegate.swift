//
//  AppDelegate.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 11/06/24.
//

import UIKit
import FirebaseCore
import GoogleMaps
import UserNotifications
import FirebaseMessaging
import FirebaseDatabase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private lazy var dependencies = RestoAppDIContainer()
    private lazy var notificationHandler = dependencies.makeNotificationHandler()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setup()
        
        notificationHandler.requestPermission()
        application.registerForRemoteNotifications()
        
        return true
    }
    
    // Force to always portrait
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        .portrait
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, error in
            if let error {
                debugPrint(error.localizedDescription)
                return
            }
            
            if let token {
                UserDefaultManager.deviceToken = token
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let deepLinkURLString = userInfo["link"] as? String, let deepLinkURL = URL(string: deepLinkURLString) {
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.handleUrl(deepLinkURL)
            }
        }
        
        completionHandler()
    }
}

private extension AppDelegate {
    func setup() {
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        notificationHandler.setDelegate(self)
        
        GMSServices.provideAPIKey(AppConfiguration.googleApiKey ?? "")
        Messaging.messaging().delegate = self
    }
}
