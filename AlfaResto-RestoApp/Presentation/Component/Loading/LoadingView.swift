//
//  LoadingView.swift
//  AlfaResto-RestoApp
//
//  Created by Axel Ganendra on 02/07/24.
//

import Foundation
import Lottie

class LoadingView: UIView {
    
    private var animationView: LottieAnimationView?
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupAnimation()
    }
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
        setupAnimation()
    }
    
    private func setupAnimation() {
        backgroundColor = UIColor.black.withAlphaComponent(0.2)
        frame = UIScreen.main.bounds
        
        animationView = LottieAnimationView(name: Constant.loading)
        
        animationView?.translatesAutoresizingMaskIntoConstraints = false
        animationView?.loopMode = .loop
        
        if let animationView {
            addSubview(animationView)
            
            NSLayoutConstraint.activate([
                animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
                animationView.centerYAnchor.constraint(equalTo: centerYAnchor),
                animationView.widthAnchor.constraint(equalToConstant: 150),
                animationView.heightAnchor.constraint(equalToConstant: 150)
            ])
        }
    }
    
    func startLoading() {
        DispatchQueue.main.async {
            self.animationView?.play()
            self.isHidden = false
        }
    }
    
    func stopAnimation() {
        DispatchQueue.main.async {
            self.animationView?.stop()
            self.isHidden = true
        }
    }
}
