//
//  ProfileViewController.swift
//  AlfaResto-RestoApp
//
//  Created by Axel Ganendra on 14/06/24.
//

import UIKit
import RxSwift
import Network

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var isTemproraryCloseSegmented: UISegmentedControl!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelOpenHours: UILabel!
    @IBOutlet weak var labelPhoneNumber: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var imageStore: UIImageView!
    @IBOutlet weak var buttonSettings: UIButton!
    
    private let depedency = RestoAppDIContainer()
    private let disposeBag = DisposeBag()
    private let network = NWPathMonitor()
    
    private var viewModel: ProfileViewModel?
    
    static var storyboardID: String {
        String(describing: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = depedency.makeProfileViewModel()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel?.fetchProfile()
    }
    
    @IBAction func onTapEditProfile(_ sender: Any) {
        moveToEditProfile()
    }
    
    @IBAction func onTapLogout(_ sender: Any) {
        setupLogout()
    }
    
    @IBAction func didSegmentedPressed(_ sender: UISegmentedControl) {
        updateTemporaryClose()
    }
}

private extension ProfileViewController {
    
    func setup() {
        viewModel?.fetchProfile()
        getData()
        checkNetwork()
        isTemproraryCloseSegmented.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
    
    func getData() {
        guard let viewModel else { return }
        viewModel.status
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .next(let result):
                    self.updateUI(with: result)
                default:
                    break
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    func updateUI(with data: ProfileStoreModel) {
        labelAddress.text = data.address
        labelPhoneNumber.text = "+62\(data.phoneNumber)"
        labelDescription.text = data.description
        imageStore.getImage(link: data.image)
        labelOpenHours.text = data.is24hours ? "Open 24 Hours" : "\(data.openingTime) - \(data.closingTime)"
        isTemproraryCloseSegmented.selectedSegmentIndex = data.isTemporaryClose ?? false ? 0 : 1
    }
    
    func moveToEditProfile() {
        let storyboard = UIStoryboard(name: EditProfileViewController.storyboardID, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: EditProfileViewController.storyboardID) as? EditProfileViewController, let viewModel else { return }
        vc.data = viewModel.data
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoLoginPage() {
        let storyboard = UIStoryboard(name: LoginViewController.storyboardID, bundle: nil)
        guard let nextView = storyboard.instantiateViewController(identifier: LoginViewController.storyboardID) as? LoginViewController else { return }
        navigationController?.setViewControllers([nextView], animated: true)
    }
    
    func setupLogout() {
        guard let viewModel else { return }
        
        Alert.show(type: .customFunc(title: "Logout", msg: "Are you sure want to sign out from this device?", onCancel: { return }, onOkay: {
            viewModel.logoutAccount().subscribe(onCompleted: {
                viewModel.updateTokenFCM(token: "")
                viewModel.invalidateFCMToken()
                UserDefaultManager.deviceToken = nil
                UserDefaultManager.restoID = nil
                self.gotoLoginPage()
            }, onError: { error in
                debugPrint(error)
                return
            }).disposed(by: viewModel.disposeBag)
        }), viewController: self)
    }
    
    func checkNetwork() {
        AccessNetwork.checkConnection(monitor: network, view: self)
    }
    
    func updateTemporaryClose() {
        switch isTemproraryCloseSegmented.selectedSegmentIndex {
        case 0:
            handleCloseSegmented()
        case 1:
            handleOpenSegmented()
        default:
            debugPrint("Segmented Out of Index")
            break
        }
        isTemproraryCloseSegmented.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
    
    func handleCloseSegmented() {
        Alert.show(type: .customFunc(title: "Close Resto", msg: "Are you sure want to close your resto", onCancel: { [weak self] in
            self?.isTemproraryCloseSegmented.selectedSegmentIndex = 1
        }, onOkay: { [weak self] in
            self?.viewModel?.updateTemporaryClose(isClose: true)
        }), viewController: self)
    }
    
    func handleOpenSegmented() {
        Alert.show(type: .customFunc(title: "Open Resto", msg: "Are you sure want to open your resto", onCancel: { [weak self] in
            self?.isTemproraryCloseSegmented.selectedSegmentIndex = 0
        }, onOkay: { [weak self] in
            self?.viewModel?.updateTemporaryClose(isClose: false)
        }), viewController: self)
    }
    
}
