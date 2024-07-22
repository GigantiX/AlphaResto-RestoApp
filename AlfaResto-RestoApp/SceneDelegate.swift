//
//  SceneDelegate.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 11/06/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        if (UserDefaultManager.restoID != nil) {
            let tabBarStoryBoard = UIStoryboard(name: TabBarController.storyboardID, bundle: nil)
            let tabBarVC = tabBarStoryBoard.instantiateViewController(identifier: TabBarController.storyboardID)
            window = UIWindow(windowScene: scene)
            window?.makeKeyAndVisible()
            window?.rootViewController = tabBarVC
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        handleUrl(url)
    }
    
}

extension SceneDelegate {
    func handleUrl(_ url: URL) {
        guard let component = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let host = component.host
        else { return }
        
        var parameter: [String: Any] = [:]
        let queryItems = component.queryItems
        queryItems?.forEach { parameter[$0.name] = $0.value }
        
        guard let deeplink = DeepLink(rawValue: host) else { return }
        handleDeepLink(deeplink, parameter: parameter)
    }
}

private extension SceneDelegate {
    func handleDeepLink(_ deeplink: DeepLink, parameter: [String: Any]) {
        switch deeplink {
        case .order:
            presentTabBar(withIndex: 2)
        case .chat:
            let orderID = parameter["order_id"] as? String
            navigateToChat(orderID: orderID ?? "")
        }
    }
    
    func navigateToChat(orderID: String) {
        let tabBarStoryboard = UIStoryboard(name: TabBarController.storyboardID, bundle: nil)
        let orderDetailStoryboard = UIStoryboard(name: OrderDetailViewController.storyboardID, bundle: nil)
        
        guard let tabBarVC = tabBarStoryboard.instantiateViewController(withIdentifier: TabBarController.storyboardID) as? TabBarController,
              let orderDetailVC = orderDetailStoryboard.instantiateViewController(withIdentifier: OrderDetailViewController.storyboardID) as? OrderDetailViewController
        else { return }
        
        let order = Order(id: orderID)
        orderDetailVC.order = order
        orderDetailVC.shouldNavigateToChat = true
        
        let navigationController = UINavigationController()
        navigationController.viewControllers = [tabBarVC, orderDetailVC]
        navigationController.isNavigationBarHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
    }
    
    func presentTabBar(withIndex index: Int) {
        let tabBarStoryBoard = UIStoryboard(name: TabBarController.storyboardID, bundle: nil)
        if let tabBarVC = tabBarStoryBoard.instantiateViewController(identifier: TabBarController.storyboardID) as? TabBarController {
            window?.rootViewController = tabBarVC
            window?.makeKeyAndVisible()
            tabBarVC.selectedIndex = index
        }
    }
}

