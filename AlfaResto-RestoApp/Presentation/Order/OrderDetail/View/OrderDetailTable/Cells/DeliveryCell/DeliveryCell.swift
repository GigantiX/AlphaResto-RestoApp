//
//  DeliveryCellTableViewCell.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 21/06/24.
//

import UIKit
import RxSwift
import GoogleMaps
import CoreLocation

protocol CancelOrderDelegate: AnyObject {
    func didTapCancelOrder()
}

class DeliveryCell: UITableViewCell {
    
    @IBOutlet private weak var addressCustomerLabel: UILabel!
    @IBOutlet private weak var updateStatusButton: UIButton!
    @IBOutlet private weak var openMapsButton: UIButton!
    @IBOutlet private weak var reRouteButton: UIButton!
    @IBOutlet private weak var mapView: UIView!
    @IBOutlet weak var buttonCancelOrder: UIButton!
    
    private let disposeBag = DisposeBag()
        
    private var status = ""
    private var title = ""
    private var body = ""
    private var link = ""
    
    var orderDetailVM: OrderDetailViewModel?
    weak var cancelDelegate: CancelOrderDelegate?
    
    static var reuseID: String {
        String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func updateStatusButtonPressed(_ sender: UIButton) {
        switch orderDetailVM?.shipment?.statusDelivery {
        case .onDelivery:
            status = "Delivered"
            title = "Pesanan sudah sampai"
            body = "Yey pesananmu sudah sampai, selamat menikmati!!"
            link = Constant.orderDetailDeepLinkUrlAndroid + "\(status)/\(orderDetailVM?.order?.id ?? "")"
            orderDetailVM?.stopUpdatingLocation()
            orderDetailVM?.setLocationValueToRealtime(latitude: 0, longitude: 0)
        case .onProcess:
            status = "On Delivery"
            title = "Pesanan sedang diantar"
            body = "Cie udah ga sabar yaa untuk makan, sabar yaa restoran sedang ngantar makananmu nih"
            link = Constant.trackOrderDeepLinkUrlAndroid + (orderDetailVM?.order?.id ?? "")
            orderDetailVM?.startUpdatingLocation()
        default:
            break
        }
        orderDetailVM?.postNotification(tokenNotification: orderDetailVM?.userToken ?? "", title: title, body: body, link: link)
        orderDetailVM?.manageShipment(orderID: orderDetailVM?.order?.id ?? "", status: status)
    }
    
    @IBAction func onTapCancelOrder(_ sender: Any) {
        cancelDelegate?.didTapCancelOrder()
    }
    @IBAction func openMapsPressed(_ sender: UIButton) {
        orderDetailVM?.openGoogleMaps()
    }
    
    @IBAction func reRoutePressed(_ sender: UIButton) {
       getDirectionMaps()
    }
}

extension DeliveryCell: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        orderDetailVM?.zoom = mapView.camera.zoom
    }
}

extension DeliveryCell {
    func configure(order: Order) {
        addressCustomerLabel.text = order.address ?? ""
        setupMapView()
        setup()
    }
}

private extension DeliveryCell {
    
    func setup() {
        updateStatusButton.layer.cornerRadius = 8
        
        switch orderDetailVM?.shipment?.statusDelivery {
        case .onProcess:
            reRouteButton.isEnabled = false
            updateStatusButton.setTitle("Deliver", for: .normal)
            orderDetailVM?.isUpdateStatusButtonEnable = false
        case .onDelivery:
            reRouteButton.isEnabled = true
            updateStatusButton.setTitle("Arrived", for: .normal)
            updateStatusButton.backgroundColor = .semiWhite
            if let isUpdateStatusButtonEnable = orderDetailVM?.isUpdateStatusButtonEnable {
                updateStatusButton.isEnabled = isUpdateStatusButtonEnable
            }
        default:
            break
        }
        
        [updateStatusButton, mapView, openMapsButton, reRouteButton, buttonCancelOrder]
            .forEach { $0?.isHidden = orderDetailVM?.shipment?.statusDelivery?.rawValue == StatusDelivery.delivered.rawValue || orderDetailVM?.shipment?.statusDelivery?.rawValue == StatusDelivery.cancelled.rawValue }
        
        buttonCancelOrder.isEnabled = orderDetailVM?.shipment?.statusDelivery?.rawValue != StatusDelivery.onDelivery.rawValue
        
        setupObserver()
    }
    
    func getDirectionMaps() {
        orderDetailVM?.getDirectionMaps(origin: orderDetailVM?.coordinate ?? CLLocationCoordinate2D(latitude: orderDetailVM?.restaurant?.latitude ?? 0, longitude: orderDetailVM?.restaurant?.longitude ?? 0), destination: CLLocationCoordinate2D(latitude: orderDetailVM?.order?.latitude ?? 0, longitude: orderDetailVM?.order?.longitude ?? 0))
    }
    
    func setupObserver() {
        orderDetailVM?.deleteLocationValueToRealtimeObservable
            .subscribe { event in
                switch event {
                default:
                    break
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    func setupMapView() {
        orderDetailVM?.gmapsView?.clear()
                
        let options = GMSMapViewOptions()
        options.frame = self.mapView.bounds
                
        orderDetailVM?.gmapsView = MapHandler.shared.getMapView(options: options)
        orderDetailVM?.gmapsView?.camera = setupCameraPosition(target: orderDetailVM?.coordinate ?? CLLocationCoordinate2D(latitude:orderDetailVM?.restaurant?.latitude ?? 0, longitude: orderDetailVM?.restaurant?.longitude ?? 0))
        orderDetailVM?.gmapsView?.isMyLocationEnabled = true
        
        orderDetailVM?.gmapsView?.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        mapView?.autoresizesSubviews = true
        orderDetailVM?.gmapsView?.settings.scrollGestures = true
        orderDetailVM?.gmapsView?.settings.myLocationButton = true
        orderDetailVM?.gmapsView?.settings.zoomGestures = true
        orderDetailVM?.gmapsView?.settings.tiltGestures = true
        
        orderDetailVM?.gmapsView?.delegate = self
        
        if let gmapsView = orderDetailVM?.gmapsView {
            self.orderDetailVM?.polyline?.map = self.orderDetailVM?.gmapsView
            self.mapView.addSubview(gmapsView)
        }
        
        setupMarker(coordinate: CLLocationCoordinate2D(latitude: (orderDetailVM?.order?.latitude ?? 0.0), longitude: (orderDetailVM?.order?.longitude ?? 0.0)))
    }
    
    func setupCameraPosition(target: CLLocationCoordinate2D) -> GMSCameraPosition {
        return GMSCameraPosition(target: target, zoom: orderDetailVM?.zoom ?? 0)
    }
    
    func setupMarker(coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        marker.map = orderDetailVM?.gmapsView
    }

}
