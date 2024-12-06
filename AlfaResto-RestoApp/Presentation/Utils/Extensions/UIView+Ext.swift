//
//  UIView+Ext.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 19/07/24.
//

import UIKit

extension UIView {
    
    func loadViewFromNib(nibName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self).first as? UIView
    }
    
}
