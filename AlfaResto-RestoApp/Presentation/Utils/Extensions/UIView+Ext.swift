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
    
    func addSkeleton(opacity: CGFloat = 1, heightMultiplier: CGFloat = 2.0) {
        removeSkeleton()
        
        let cornerRadius: CGFloat = 5
        let angle = CGFloat(11)
        let maxGradientHeight = 100.0
        let gradientHeight = bounds.height * heightMultiplier
        let gradientY = (gradientHeight - bounds.height) / -2
        
        let size = CGRect(
            x: -bounds.width,
            y: gradientY,
            width: bounds.width * 3,
            height: min(gradientHeight, maxGradientHeight)
        )
        
        let baseLayer = CALayer()
        baseLayer.backgroundColor = UIColor(named: "WhiteGrey")?.cgColor
        baseLayer.frame = bounds
        baseLayer.cornerRadius = cornerRadius
        baseLayer.name = "ShimmerBaseLayer"
        
        let overlayLayer = CALayer()
        overlayLayer.backgroundColor = UIColor.white.withAlphaComponent(opacity).cgColor
        overlayLayer.frame = bounds
        overlayLayer.cornerRadius = cornerRadius
        overlayLayer.name = "ShimmerOverlayLayer"
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.white.cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.frame = size
        gradientLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        gradientLayer.name = "ShimmerGradientLayer"
        
        let animationGradient = CABasicAnimation(keyPath: "transform.translation.x")
        animationGradient.duration = 1
        animationGradient.fromValue = -bounds.width
        animationGradient.toValue = bounds.width
        animationGradient.repeatCount = Float.infinity
        gradientLayer.add(animationGradient, forKey: "AnimateGradient")
        
        layer.addSublayer(baseLayer)
        overlayLayer.mask = gradientLayer
        layer.addSublayer(overlayLayer)
    }
    
    func removeSkeleton() {
        layer.sublayers?
            .filter { $0.name == "ShimmerBaseLayer" || $0.name == "ShimmerOverlayLayer" }
            .forEach { $0.removeFromSuperlayer() }
    }
    
}
