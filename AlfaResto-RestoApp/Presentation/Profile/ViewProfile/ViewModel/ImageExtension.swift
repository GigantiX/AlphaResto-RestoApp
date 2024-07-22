//
//  ImageExtension.swift
//  AlfaResto-RestoApp
//
//  Created by Axel Ganendra on 14/06/24.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func getImage(link: String) {
        let placeHolder = UIImage(named: "thumbnail")
        
        guard let url = URL(string: link) else {
            return
        }
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url, placeholder: placeHolder)
    }
}
