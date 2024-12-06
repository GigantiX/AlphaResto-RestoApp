//
//  BadgeView.swift
//  AlfaResto-RestoApp
//
//  Created by Axel Ganendra on 19/07/24.
//

import Foundation
import UIKit

class BadgeView: UIView {
    private var label: UILabel!
    
    var text: String? {
        didSet {
            label.text = text
            layoutIfNeeded()
        }
    }
    
    var badgeColor: UIColor = .red {
        didSet {
            backgroundColor = badgeColor
        }
    }
    
    var textColor: UIColor = .white {
        didSet {
            label.textColor = textColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = badgeColor
        layer.cornerRadius = frame.size.height / 2
        clipsToBounds = true
        
        label = UILabel()
        label.textColor = textColor
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.height / 2
    }
}
