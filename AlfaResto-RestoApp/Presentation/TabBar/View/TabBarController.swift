//
//  TabBarController.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 14/06/24.
//

import UIKit
import RxSwift

final class TabBarController: UITabBarController {
    
    private let dependencies = RestoAppDIContainer()
    private let diposeBag = DisposeBag()
    
    private lazy var tabBarVM = dependencies.makeTabBarViewModel()
    
    static var storyboardID: String {
        String(describing: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
}

//extension TabBarController {
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        tabBarVM.getOnGoingOrderCount()
//    }
//}

private extension TabBarController {
    
    func setup() {
        tabBarVM.getOnGoingOrderCount()

        setupObservable()
        setupTabBar()
    }
    
    func setupTabBar() {
        
        let profileStoryboard = UIStoryboard(name: ProfileViewController.storyboardID, bundle: nil)
        let listMenuStoryboard = UIStoryboard(name: ListMenuViewController.storyboardID, bundle: nil)
        let orderStoryboard = UIStoryboard(name: OrderViewController.storyboardID, bundle: nil)
        
        let profileVC = profileStoryboard.instantiateViewController(withIdentifier: ProfileViewController.storyboardID)
        let listMenuVC = listMenuStoryboard.instantiateViewController(withIdentifier: ListMenuViewController.storyboardID)
        let orderVC = orderStoryboard.instantiateViewController(withIdentifier: OrderViewController.storyboardID)
        
        let profileNC = UINavigationController(rootViewController: profileVC)
        profileNC.setNavigationBarHidden(true, animated: true)
        
        let listMenuNC = UINavigationController(rootViewController: listMenuVC)
        listMenuNC.setNavigationBarHidden(true, animated: true)
        
        let orderNC = UINavigationController(rootViewController: orderVC)
        orderNC.setNavigationBarHidden(true, animated: true)
        
        profileNC.tabBarItem = UITabBarItem(title: Constant.profile, image: Constant.profileTabBarImage, selectedImage: Constant.selectedProfileTabBarImage)
        listMenuNC.tabBarItem = UITabBarItem(title: Constant.menu, image: Constant.menuTabBarImage, selectedImage: Constant.selectedMenuTabBarImage)
        orderNC.tabBarItem = UITabBarItem(title: Constant.order, image: Constant.orderTabBarImage, selectedImage: Constant.selectedOrderTabBarImage)
        
        UITabBar.appearance().unselectedItemTintColor = UIColor.mainGray
        
        viewControllers = [profileNC, listMenuNC, orderNC]
    }
    
    func setupObservable() {
        tabBarVM.getOnGoingOrderCountObservable
            .subscribe { [weak self] event in
                switch event {
                case .next(.success):
                    self?.tabBar.items?[2].badgeValue =  self?.tabBarVM.onGoingOrderCount ?? 0 > 0 ? "\(self?.tabBarVM.onGoingOrderCount ?? 0)" : nil
                default:
                    break
                }
            }
            .disposed(by: self.diposeBag)
    }
}
