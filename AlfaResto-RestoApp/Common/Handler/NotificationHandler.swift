//
//  NotificationHandler.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 27/06/24.
//

import UIKit
import UserNotifications

enum NotificationType {
    case chat
    case shipment
}

protocol NotificationHandler {
    func requestPermission()
    func sendNotification(token: String?, title: String?, body: String?, date: Date?, type: NotificationType)
    func logNotification()
    func removeNotification(token: String)
    func removeAllNotification()
    func setDelegate(_ appDelegate: UIApplicationDelegate)
}

final class NotificationHandlerImpl {
    init() { }
}

extension NotificationHandlerImpl: NotificationHandler {
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, error in
            if let error {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func sendNotification(token: String?, title: String?, body: String?, date: Date?, type: NotificationType) {
        self.removeNotification(token: token ?? "")
                
        guard let title, let body else { return }
        
        var trigger: UNCalendarNotificationTrigger?
        
        switch type {
        case .chat:
            let dateComponent = date?.getDateComponent([.hour, .minute, .second]) ?? DateComponents()
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        case .shipment:
            let dateComponent = date?.getFullTimeDateComponent() ?? DateComponents()
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: token ?? "", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        
        logNotification()
    }
    
    func logNotification() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notif in
            debugPrint("Notif Pending: \(notif)")
        }
        
        UNUserNotificationCenter.current().getDeliveredNotifications { notif in
            debugPrint("Notif Delivered: \(notif)")
        }
    }
    
    func removeNotification(token: String) {
        let tokens: [String] = [token]
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: tokens)
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: tokens)
    }
    
    func removeAllNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func setDelegate(_ appDelegate: UIApplicationDelegate) {
        UNUserNotificationCenter.current().delegate = appDelegate as? UNUserNotificationCenterDelegate
    }
}
