//
//  OrderDetailViewController.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 21/06/24.
//

import UIKit
import CoreLocation
import RxSwift

final class OrderDetailViewController: UIViewController {
    
    @IBOutlet private weak var customerNameLabel: UILabel!
    @IBOutlet weak var buttonChat: UIButton!
    
    private let dependency = RestoAppDIContainer()
    private let disposeBag = DisposeBag()
    private let distanceFilter: CLLocationDistance = 50
    private let loadingView = LoadingView(frame: .zero)
    
    private var orderDetailTableVC: OrderDetailTableViewController?
    private var lastLocation: CLLocation?
    
    private lazy var badgeView: BadgeView = {
        var badge = BadgeView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        badge.text = "N"
        badge.badgeColor = .red
        badge.textColor = .white
        return badge
    }()
    private lazy var orderDetailVM: OrderDetailViewModel = dependency.makeOrderDetailViewModel()
    
    var order: Order?
    var shouldNavigateToChat = false
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == OrderDetailTableViewController.segueIdentifier,
           let destinationVC = segue.destination as? OrderDetailTableViewController {
            orderDetailTableVC = destinationVC
            orderDetailTableVC?.orderDetailVM = orderDetailVM
        }
    }
        
    static var storyboardID: String {
        String(describing: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkPermission()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getOrder()
        setup()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        orderDetailVM.stopUpdatingLocation()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func chatButtonPressed(_ sender: UIButton) {
        goToChatPage()
    }
}

extension OrderDetailViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        let coordinate = location.coordinate
        
        orderDetailVM.coordinate = coordinate
        orderDetailVM.checkIsAlreadyNotifyWhen50m()
        
        updateLocationToRealtime(from: location, with: coordinate)
        checkDestinationIsClose(from: location)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkPermission()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        orderDetailVM.stopUpdatingLocation()
    }
}

private extension OrderDetailViewController {
    func setup() {
        setupLoadingView()
        self.swipe(.right)
        orderDetailVM.setLocationDelegate(self)
        setupObserver()
        setupBadge()
        
    }
    
    func setupLoadingView() {
        view.addSubview(loadingView)
        loadingView.isHidden = true
        NSLayoutConstraint.activate([
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupBadge() {
        buttonChat.addSubview(badgeView)
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        badgeView.isHidden = true
        
        NSLayoutConstraint.activate([
            badgeView.trailingAnchor.constraint(equalTo: buttonChat.trailingAnchor, constant: 5),
            badgeView.topAnchor.constraint(equalTo: buttonChat.topAnchor, constant: -5),
            badgeView.widthAnchor.constraint(greaterThanOrEqualToConstant: 20),
            badgeView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func setStatusChat() {
        guard let order = orderDetailVM.order else { return }
        badgeView.isHidden = order.readStatus ?? true
    }
    
    func setupObserver() {
        orderDetailVM.getOrderDetailObservable
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .next(.success):
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        if self.shouldNavigateToChat {
                            self.goToChatPage()
                        }
                        self.orderDetailTableVC?.reload()
                        self.customerNameLabel.text = self.orderDetailVM.order?.userName ?? "No Name"
                        setStatusChat()
                    }
                default:
                    break
                }
            }.disposed(by: self.disposeBag)
        
        orderDetailVM.getShipmentDetailObservable
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .next(.success):
                    self.loadingView.stopAnimation()
                    self.startUpdatingStatusWhenOnDelivery()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                        guard let self else { return }
                        if self.orderDetailVM.shipment?.statusDelivery?.rawValue == StatusDelivery.onDelivery.rawValue {
                            self.getDirectionMaps()
                        }
                        self.orderDetailTableVC?.reload()
                    }
                default:
                    break
                }
            }.disposed(by: self.disposeBag)
        
        orderDetailVM.updateIsAlreadyNotifyWhen50mObservable
            .subscribe { event in
                switch event {
                case .next(.success):
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        self.orderDetailTableVC?.reload()
                    }
                default:
                    break
                }
            }.disposed(by: self.disposeBag)
        
        orderDetailVM.getDirectionMapsObservable
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .next(.success):
                    self.orderDetailTableVC?.reload()
                default:
                    break
                }
            }
            .disposed(by: self.disposeBag)
        
        orderDetailVM.manageShipmentObservable.subscribe {
            [weak self] event in
            guard let self else { return }
            
            switch event {
            case .next(_):
                DispatchQueue.main.async {
                    self.orderDetailTableVC?.reload()
                }
            case .error(let error):
                debugPrint(error)
            default:
                break
            }
        }.disposed(by: self.disposeBag)
        
        orderDetailVM.chatStatusObservable.subscribe {
            [weak self] event in
            guard let self else { return }
            
            switch event {
            case .next(_):
                DispatchQueue.main.async {
                    self.badgeView.isHidden = true
                }
            case .error(let error):
                debugPrint(error)
            default:
                break
            }
        }.disposed(by: self.disposeBag)
    }
    
    func checkPermission() {
        switch orderDetailVM.getStatusPermission() {
        case .notDetermined:
            orderDetailVM.requestPermission()
        case .restricted, .denied:
            Alert.show(type: .customFunc(title: "Location Denied", msg:  "Customer need your location to track the progress, please go to Setting > AlfaResto-RestoApp > Location > Always", onCancel: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }, onOkay: {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }), viewController: self)
        case .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            debugPrint("Error Check Permission")
        }
    }
    
    func getOrder() {
        guard let order, let id = order.id else { return }
        loadingView.startLoading()
        orderDetailVM.getOrderDetail(orderID: id)
        orderDetailVM.getAllOrderItemFrom(orderID: id)
        orderDetailVM.getShipmentDetailWith(orderID: id)
        orderDetailVM.getRestoCoordinate()
    }
    
    func updateLocationToRealtime(from location: CLLocation, with coordinate: CLLocationCoordinate2D) {
        let filter: CLLocationDistance = 50
        if let lastLocation {
            let distance = location.distance(from: lastLocation)
            if distance >= filter {
                orderDetailVM.setLocationValueToRealtime(latitude: coordinate.latitude, longitude: coordinate.longitude)
                self.lastLocation = location
            }
        } else {
            orderDetailVM.setLocationValueToRealtime(latitude: coordinate.latitude, longitude: coordinate.longitude)
            self.lastLocation = location
        }
    }
    
    func isDestinationClose(from location: CLLocation, distanceFilter: CLLocationDistance) -> Bool {
        location.distance(from: CLLocation(latitude: orderDetailVM.order?.latitude ?? 0, longitude: orderDetailVM.order?.longitude ?? 0)) <= distanceFilter
    }
    
    func getDirectionMaps() {
        orderDetailVM.getDirectionMaps(origin: orderDetailVM.coordinate ?? CLLocationCoordinate2D(latitude: orderDetailVM.restaurant?.latitude ?? 0, longitude: orderDetailVM.restaurant?.longitude ?? 0), destination: CLLocationCoordinate2D(latitude: orderDetailVM.order?.latitude ?? 0, longitude: orderDetailVM.order?.longitude ?? 0))
    }
    
    func notifyUserWhenItClose() {
        if !(orderDetailVM.isNotify ?? true) {
            orderDetailVM.postNotification(tokenNotification: orderDetailVM.userToken ?? "", title: "Orderan kamu sebentar lagi sampai nih", body: "Driver sebentar lagi sampai ayuk siap-siap!!", link: Constant.trackOrderDeepLinkUrlAndroid + (order?.id ?? ""))
            orderDetailVM.updateIsAlreadyNotifyWhen50m()
        }
    }
   
    func updateEnableStatusButtonAndZoom(status: Bool, zoom: Float?) {
        orderDetailVM.isUpdateStatusButtonEnable = status
        if let zoom {
            orderDetailVM.zoom = zoom
        }
    }
    
    func startUpdatingStatusWhenOnDelivery() {
        if orderDetailVM.shipment?.statusDelivery?.rawValue == StatusDelivery.onDelivery.rawValue {
            orderDetailVM.startUpdatingLocation()
            orderDetailVM.isUpdateStatusButtonEnable = false
        }
    }
    
    func checkDestinationIsClose(from location: CLLocation) {
        isDestinationClose(from: location, distanceFilter: self.distanceFilter) ? handleDestinationClose() : handleDestinationNotClose()
    }
    
    func handleDestinationClose() {
        notifyUserWhenItClose()
        if orderDetailVM.isUpdateStatusButtonEnable == false {
            updateEnableStatusButtonAndZoom(status: true, zoom: 18.0)
            orderDetailTableVC?.reload()
        }
    }
    
    func handleDestinationNotClose() {
        if orderDetailVM.isUpdateStatusButtonEnable == true {
            updateEnableStatusButtonAndZoom(status: false, zoom: nil)
            orderDetailTableVC?.reload()
        }
    }
    
    func goToChatPage() {
        orderDetailVM.setToReadChat(orderID: orderDetailVM.order?.id ?? "")
        
        let storyboard = UIStoryboard(name: RestoChatViewController.storyboardID, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: RestoChatViewController.storyboardID) as? RestoChatViewController else { return }
        
        vc.order = orderDetailVM.order
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
