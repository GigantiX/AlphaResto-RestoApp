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
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet weak var stockMenuLabel: UILabel!
    
    var menu: Menu?
    
    var didEditTapped: (() throws -> Void)?
    
    static var reuseID: String {
        String(describing: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        menuImageView.image = nil
    }

    @IBAction func editButtonPressed(_ sender: UIButton) {
        do {
            try didEditTapped?()
        } catch {
            debugPrint("Error")
        }
    }
    
}

extension ListMenuItemCell {
    func configure(menu: Menu) {
        self.menuTitleLabel.text = menu.menuName
        self.menuDescriptionLabel.text = menu.menuDescription
        self.menuPriceLabel.text = menu.menuPrice?.formatToRupiah()
        self.menuImageView.getImage(link: menu.menuImage ?? "")
        self.stockMenuLabel.text = "Stock: \(menu.stock ?? 0)"
        self.stockMenuLabel.textColor = menu.stock == 0 ? .danger : .black
    }
}

private extension ListMenuItemCell {
    func setup() {
        layer.cornerRadius = 10
        
        menuImageView.layer.cornerRadius = 10
        editButton.layer.cornerRadius = 5
    }
}
