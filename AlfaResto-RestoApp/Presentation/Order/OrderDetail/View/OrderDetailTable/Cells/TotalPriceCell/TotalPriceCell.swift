//
//  TotalPriceCell.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 21/06/24.
//

import UIKit

class TotalPriceCell: UITableViewCell {
    
    @IBOutlet weak var labelNotesOrder: UILabel!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    
    static var reuseID: String {
        String(describing: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension TotalPriceCell {
    func configure(order: Order) {
        totalPriceLabel.text = order.totalPrice?.formatToRupiah()
        labelNotesOrder.text = order.notes
    }
}
