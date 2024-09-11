//
//  OrderViewController.swift
//  AlfaResto-RestoApp
//
//  Created by Axel Ganendra on 23/06/24.
//

import UIKit
import RxSwift

class OrderViewController: UIViewController {
    @IBOutlet weak var buttonFilter: UIButton!
    @IBOutlet weak var tableviewOrder: UITableView!
    @IBOutlet weak var segmentedOrder: UISegmentedControl!
    
    private let dependencies = RestoAppDIContainer()
    private let disposeBag = DisposeBag()
    private let loadingView = LoadingView(frame: .zero)
    private let orderRefreshControl = UIRefreshControl()
    
    private lazy var orderVM = dependencies.makeOrderViewModel()
    
    static var storyboardID: String {
        String(describing: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchBySegmentedOrder()
    }
    
    @IBAction func segmentedOrderAction(_ sender: UISegmentedControl) {
        fetchBySegmentedOrder()
    }
}

extension OrderViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderVM.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        do {
            let order = try orderVM.data.item(at: indexPath.row)
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.identifier) as? OrderTableViewCell, let id = order.id else { return UITableViewCell() }
            cell.selectionStyle = .none
            let status = orderVM.shipmentData[id]
            
            DispatchQueue.main.async {
                cell.setupCell(using: order, status: status)
            }
            return cell
        } catch {
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailStoryboard = UIStoryboard(name: OrderDetailViewController.storyboardID, bundle: nil)
        guard let vc = detailStoryboard.instantiateViewController(withIdentifier: OrderDetailViewController.storyboardID) as? OrderDetailViewController else { return }
        
        vc.order = orderVM.data[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

private extension OrderViewController {
    func setup() {
        setupLoadingView()
        setupSegmented()
        setupObserver()
        setupTableView()
        setupFilter()
        setupRefreshControl()
    }
    
    func setupSegmented() {
        let selectedColor: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        
        segmentedOrder.setTitleTextAttributes(selectedColor, for: .selected)
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
    
    func setupRefreshControl() {
        orderRefreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        tableviewOrder.refreshControl = orderRefreshControl
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        fetchBySegmentedOrder()
    }
    
    func setupFilter() {
        buttonFilter.menu = UIMenu(children:[
            UIAction(title: "Latest",state: .on, handler: { [weak self] _ in
                guard let self else { return }
                self.orderVM.descending = true
                self.fetchBySegmentedOrder()
            }),
            UIAction(title: "Oldest", handler: {[weak self] _ in
                guard let self else { return }
                self.orderVM.descending = false
                self.fetchBySegmentedOrder()
            }),
        ])
        buttonFilter.showsMenuAsPrimaryAction = true
        buttonFilter.changesSelectionAsPrimaryAction = true
    }
    
    func setupTableView() {
        tableviewOrder.register(OrderTableViewCell.orderCellNib(), forCellReuseIdentifier: OrderTableViewCell.identifier)
        tableviewOrder.dataSource = self
        tableviewOrder.delegate = self
    }
    
    func fetchBySegmentedOrder() {
        switch segmentedOrder.selectedSegmentIndex {
        case 0:
            fetchOngoing()
        case 1:
            fetchHistory()
        default:
            break
        }
    }
    
    func setupObserver() {
        orderVM.observeShipment.subscribe(onNext: { _ in
            DispatchQueue.main.async {
                self.loadingView.stopAnimation()
                self.tableviewOrder.reloadData()
            }
        }, onError: { error in
            self.loadingView.stopAnimation()
            debugPrint(error)
        }).disposed(by: self.disposeBag)
        
        orderVM.observeFetch
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .next(.success):
                    DispatchQueue.main.async {
                        self.tableviewOrder.reloadData()
                    }
                default:
                    break
                }
            }.disposed(by: self.disposeBag)
        
        orderVM.observeHistory
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .next(.success):
                    DispatchQueue.main.async {
                        self.tableviewOrder.reloadData()
                    }
                default:
                    break
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    func fetchOngoing() {
        loadingView.startLoading()
        orderVM.fetchOngoingOrder()
    }
    
    func fetchHistory() {
        loadingView.startLoading()
        orderVM.fetchHistoryOrder()
    }
}
