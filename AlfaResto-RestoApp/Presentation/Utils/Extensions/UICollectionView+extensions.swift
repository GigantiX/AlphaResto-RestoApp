//
//  UICollectionView+extensions.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 25/06/24.
//

import UIKit

extension UICollectionView {
    
    var defaultIdentifier: String {
        "BaseCell"
    }
    
    func registerBaseCell() {
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: defaultIdentifier)
    }
    
}
