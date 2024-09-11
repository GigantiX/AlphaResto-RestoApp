//
//  OrderTableViewCell.swift
//  AlfaResto-RestoApp
//
//  Created by Axel Ganendra on 22/06/24.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    @IBOutlet weak var textDate: UILabel!
    @IBOutlet weak var textQuantity: UILabel!
    @IBOutlet weak var textPrice: UILabel!
    @IBOutlet weak var textName: UILabel!
    @IBOutlet weak var textStatus: UILabel!
    
    @IBOutlet weak var imageIconBadge: UIImageView!
    
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var viewBadge: UIView!
    
    static var identifier: String {
        String(describing: self)
    }
    static func orderCellNib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewBadge.layer.cornerRadius = 5
        viewStatus.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension OrderTableViewCell {
    func setupCell(using data: Order, status: Shipment??) {
        textName.text = data.userName
        textDate.text = data.orderDate?.dateToString(to: .complete)
        textStatus.text = (status??.statusDelivery?.getStatus() ?? "On Process")
        textPrice.text = "IDR \((data.totalPrice ?? 0) / 1000)K"
        textQuantity.text = getQuantityOrderItem(data: data.orderItems)
        
        imageIconBadge.image = (status??.statusDelivery?.getIconImage() ?? UIImage(systemName: "takeoutbag.and.cup.and.straw"))
        
        
        viewBadge.backgroundColor = (status??.statusDelivery?.getColor() ?? .main)
        viewStatus.backgroundColor = (status??.statusDelivery?.getColor() ?? .main)
    }
    
    private func getQuantityOrderItem(data: [OrderItem]) -> String {
        var quantity = 0
        for items in data {
            quantity += items.quantity ?? 0
        }
        return "| \(quantity) items"
    }
}
