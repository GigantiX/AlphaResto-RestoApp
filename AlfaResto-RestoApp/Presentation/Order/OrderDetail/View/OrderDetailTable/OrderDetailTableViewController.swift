//
//  OrderDetailTableViewController.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 21/06/24.
//

import UIKit

final class OrderDetailTableViewController: UITableViewController {
    
    var orderDetailVM: OrderDetailViewModel?
    
    static var segueIdentifier: String {
        String(describing: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func reload() {
        tableView.reloadData()
    }
    
}

extension OrderDetailTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            orderDetailVM?.orderItems?.count ?? 0
        default:
            1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StatusShipmentItemCell.reuseID, for: indexPath) as? StatusShipmentItemCell,
                  let order = orderDetailVM?.order
            else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.configure(order: order, shipment: orderDetailVM?.shipment)
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderItemCell.reuseID, for: indexPath) as? OrderItemCell,
                  let orderItems = orderDetailVM?.orderItems
            else { return UITableViewCell() }
            cell.selectionStyle = .none
            do {
                try cell.configure(orderItems: orderItems.item(at: indexPath.row))
            } catch {
                debugPrint("Index out of range")
            }
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TotalPriceCell.reuseID, for: indexPath) as? TotalPriceCell,
                  let order = orderDetailVM?.order
            else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.configure(order: order)
            
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DeliveryCell.reuseID, for: indexPath) as? DeliveryCell,
                  let order = orderDetailVM?.order
            else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.orderDetailVM = orderDetailVM
            cell.configure(order: order)
            cell.cancelDelegate = self
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}

extension OrderDetailTableViewController: CancelOrderDelegate {
    func didTapCancelOrder() {
        guard let orderDetailVM else { return }
        
        Alert.show(type: .destructive(title: "Cancel Order Confirmation", msg: "Are you sure you want to cancel your order? This action cannot be undone.", destructiveTitle: "Okay", destructiveAction: {
            orderDetailVM.manageShipment(orderID: orderDetailVM.order?.id ?? "", status: StatusDelivery.cancelled.rawValue)
            orderDetailVM.postNotification(tokenNotification: orderDetailVM.userToken ?? "", title: "Pesanan Kamu Dibatalkan", body: "Pesanan kamu telah dibatalkan oleh resto", link: Constant.orderDetailDeepLinkUrlAndroid + "\(StatusDelivery.cancelled.rawValue)/\(orderDetailVM.order?.id ?? "")")
        }), viewController: self)
    }
}

private extension OrderDetailTableViewController {
    func setup() {
        self.tableView.separatorStyle = .none
        
        setupCell()
    }
    
    func setupCell() {
        let statusShipmentCellNib = UINib(nibName: StatusShipmentItemCell.reuseID, bundle: nil)
        let orderItemCellNib = UINib(nibName: OrderItemCell.reuseID, bundle: nil)
        let totalPriceCellNib = UINib(nibName: TotalPriceCell.reuseID, bundle: nil)
        let deliverytCellNib = UINib(nibName: DeliveryCell.reuseID, bundle: nil)
        
        tableView.register(statusShipmentCellNib, forCellReuseIdentifier: StatusShipmentItemCell.reuseID)
        tableView.register(orderItemCellNib, forCellReuseIdentifier: OrderItemCell.reuseID)
        tableView.register(totalPriceCellNib, forCellReuseIdentifier: TotalPriceCell.reuseID)
        tableView.register(deliverytCellNib, forCellReuseIdentifier: DeliveryCell.reuseID)
    }
}
