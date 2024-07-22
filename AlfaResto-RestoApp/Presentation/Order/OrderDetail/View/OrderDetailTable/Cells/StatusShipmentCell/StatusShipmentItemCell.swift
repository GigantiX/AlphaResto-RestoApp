//
//  StatusOrderItemCell.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 21/06/24.
//

import UIKit

class StatusShipmentItemCell: UITableViewCell {
    
    @IBOutlet private weak var deliveryStatusLabel: UILabel!
    @IBOutlet private weak var orderIdLabel: UILabel!
    @IBOutlet private weak var orderDateLabel: UILabel!
            
    override func prepareForReuse() {
        super.prepareForReuse()
        orderIdLabel.text = nil
        orderDateLabel.text = nil
        deliveryStatusLabel.text = nil
    }
    
    static var reuseID: String {
        String(describing: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension StatusShipmentItemCell {
    func setup() {
        deliveryStatusLabel.layer.cornerRadius = 10
        deliveryStatusLabel.clipsToBounds = true
    }
    
    func configure(order: Order, shipment: Shipment?) {
        deliveryStatusLabel.text = shipment == nil ? "On Progress" : shipment?.statusDelivery?.getStatus()
        deliveryStatusLabel.backgroundColor = shipment == nil ? .main : shipment?.statusDelivery?.getColor()
        orderIdLabel.text = "Order ID: \(order.id ?? "")"
        orderDateLabel.text = order.orderDate?.dateToString(to: .complete)
    }
}
