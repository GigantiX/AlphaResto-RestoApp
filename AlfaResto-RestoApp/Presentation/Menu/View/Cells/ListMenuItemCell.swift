//
//  ListMenuItemCellCollectionViewCell.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 17/06/24.
//

import UIKit

class ListMenuItemCell: UICollectionViewCell {
    
    @IBOutlet private weak var menuImageView: UIImageView!
    @IBOutlet private weak var menuTitleLabel: UILabel!
    @IBOutlet private weak var menuDescriptionLabel: UILabel!
    @IBOutlet private weak var menuPriceLabel: UILabel!
    @IBOutlet private weak var menuStockLabel: UILabel!
    @IBOutlet private weak var editButton: UIButton!
    
    static var reuseID: String {
        String(describing: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

}

extension ListMenuItemCell {
    func configure(menu: Menu) {
        self.menuTitleLabel.text = menu.menuName
        self.menuDescriptionLabel.text = menu.menuDescription
        self.menuPriceLabel.text = "\(menu.menuPrice)"
        self.menuStockLabel.text = "Stock: \(menu.menuStock)"
    }
}

private extension ListMenuItemCell {
    func setup() {
        layer.cornerRadius = 10
        
        editButton.layer.cornerRadius = 5
    }
}
