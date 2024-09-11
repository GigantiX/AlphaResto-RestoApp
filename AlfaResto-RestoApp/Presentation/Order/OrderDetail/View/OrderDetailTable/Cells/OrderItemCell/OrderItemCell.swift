//
//  OrderItemCell.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 21/06/24.
//

import UIKit

class OrderItemCell: UITableViewCell {
    
    @IBOutlet private weak var qtyLabel: UILabel!
    @IBOutlet private weak var orderItemLabel: UILabel!
    
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

extension OrderItemCell {
    func configure(orderItems: OrderItem) {
        qtyLabel.text = "\(orderItems.quantity ?? 0)x"
        orderItemLabel.text = orderItems.menuName ?? ""
    }
}
