//
//  UIViewController+extensions.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 18/06/24.
//

import UIKit

extension UIViewController {
    func swipe(_ direction: UISwipeGestureRecognizer.Direction) {
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(popViewWithHands(_:)))
        rightGesture.direction = direction
        self.view.addGestureRecognizer(rightGesture)
    }
}

private extension UIViewController {
    @objc
    func popViewWithHands(_ sender: UISwipeGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
}
