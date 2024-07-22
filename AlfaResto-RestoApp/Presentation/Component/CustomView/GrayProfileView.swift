//
//  GrayProfileView.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 19/07/24.
//

import UIKit

class GrayProfileView: UIView {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    
    static var nibName: String {
        String(describing: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

extension GrayProfileView {
    func initView(title: String, content: String) {
        guard let view = self.loadViewFromNib(nibName: GrayProfileView.nibName) else { return }
        
        view.frame = self.bounds
        self.layer.cornerRadius = 11
        self.clipsToBounds = true
        
        setupOutlet(title: title, content: content)
        
        self.addSubview(view)
    }
}

private extension GrayProfileView {
    func setupOutlet(title: String, content: String) {
        titleLabel.text = title
        contentLabel.text = content
    }
}
