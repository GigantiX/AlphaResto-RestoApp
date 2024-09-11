//
//  UIImageView+extensions.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 19/06/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    func getImage(link: String) {
        guard let url = URL(string: link) else {
            return
        }
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url)
    }
    
    func makeImageInteractable(vc: UIViewController, selector: Selector) {
        let tap = UITapGestureRecognizer(target: vc, action: selector)
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
}
