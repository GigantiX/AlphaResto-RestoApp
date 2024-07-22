//
//  LoginViewController.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 13/06/24.
//

import UIKit
import RxSwift
import Lottie
import IQKeyboardManagerSwift

final class LoginViewController: UIViewController {
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var showPasswordButton: UIButton!
    @IBOutlet private weak var errorMessageLabel: UILabel!
    
    private let dependencies = RestoAppDIContainer()
    private let disposeBag = DisposeBag()
    private let loadingView = LoadingView(frame: .zero)
    private lazy var notificationHandler = dependencies.makeNotificationHandler()
    
    private lazy var loginVM: LoginViewModel = dependencies.makeLoginViewModel()
    
    private var isShowPassword = false
    
    static var storyboardID: String {
        String(describing: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endTextFieldEditing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func showButtonPressed(_ sender: UIButton) {
        updateShowPasswordButton()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        login()
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        displayErrorMessage(message: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endTextFieldEditing()
        
        return true
    }
}

private extension LoginViewController {
    func setup() {
        displayErrorMessage(message: nil)
        
        [emailTextField, passwordTextField].forEach { $0?.layer.cornerRadius = 12 }
        
        emailTextField.layer.masksToBounds = true
        emailTextField.delegate = self
        
        passwordTextField.layer.masksToBounds = true
        passwordTextField.delegate = self
        
        setupLoadingView()
        setupObservable()
        removeAllNotifications()
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
    
    func removeAllNotifications() {
        notificationHandler.removeAllNotification()
    }
    
    func setupObservable() {
        loginVM.loginObservable.subscribe { [weak self] event in
            guard let self else { return }
            switch event {
            case .next(.success(let uid)):
                self.loadingView.stopAnimation()
                DispatchQueue.main.async {
                    UserDefaultManager.restoID = uid
                    self.loginVM.updateFCMToken(token: UserDefaultManager.deviceToken ?? "")
                    self.goToNextPage()
                }
            case .next(.failure(_)):
                self.loadingView.stopAnimation()
                DispatchQueue.main.async {
                    self.displayErrorMessage(message: Constant.invalidData)
                }
            default:
                break
            }
        }.disposed(by: self.disposeBag)
    }
    
    func updateShowPasswordButton() {
        passwordTextField.isSecureTextEntry = isShowPassword
        showPasswordButton.setImage(isShowPassword ? Constant.showPasswordEnableImage : Constant.showPasswordDisableImage, for: .normal)

        self.isShowPassword = !isShowPassword
    }
    
    func login() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            emailTextField.text = ""
            passwordTextField.text = ""
            return
        }
        
        loadingView.startLoading()
        
        do {
            try loginVM.login(email: email, password: password)
        } catch {
            self.loadingView.stopAnimation()
            displayErrorMessage(message: Constant.allFieldMustBeFilled)
        }
        
        endTextFieldEditing()
    }
    
    func displayErrorMessage(message text: String?) {
        if let text {
            errorMessageLabel.text = text
            errorMessageLabel.isHidden = false
        } else {
            errorMessageLabel.isHidden = true
        }
    }
    
    func endTextFieldEditing() {
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
    }
    
    func goToNextPage() {
        let tabBarStoryboard = UIStoryboard(name: TabBarController.storyboardID, bundle: nil)
        
        if let tabBarVC = tabBarStoryboard.instantiateViewController(withIdentifier: TabBarController.storyboardID) as? TabBarController {
            self.navigationController?.pushViewController(tabBarVC, animated: true)
        }
    }
    
}

