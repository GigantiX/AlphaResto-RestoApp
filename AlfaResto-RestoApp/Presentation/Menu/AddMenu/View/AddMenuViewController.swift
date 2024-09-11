//
//  AddMenuViewController.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 18/06/24.
//

import UIKit
import RxSwift
import IQKeyboardManagerSwift

final class AddMenuViewController: UIViewController {
    
    @IBOutlet private weak var textFieldStock: UITextField!
    @IBOutlet private weak var menuNameTextField: UITextField!
    @IBOutlet private weak var addImageButton: UIImageView!
    @IBOutlet private weak var menuPriceTextField: UITextField!
    @IBOutlet private weak var menuDescriptionTextView: UITextView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    
    private let dependencies = RestoAppDIContainer()
    private let disposeBag = DisposeBag()
    private let loadingView = LoadingView(frame: .zero)
    private lazy var addMenuVM = dependencies.makeAddMenuViewModel()
    
    private var menuImage = UIImage()
    
    static var storyboardID: String {
        String(describing: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endTextFieldEditing()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addImageButtonPressed(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func saveMenuButtonPressed(_ sender: UIButton) {
        addMenu()
    }
}

extension AddMenuViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            addImageButton.image = selectedImage
            
            self.menuImage = selectedImage
        }
    
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension AddMenuViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constant.defaultMenuDescription
            textView.textColor = UIColor.lightGray
        }
    }
}

extension AddMenuViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        saveButton.isEnabled = isSavable()
    }
}

private extension AddMenuViewController {
    func setup() {
        setupLoadingView()
        saveButton.isEnabled = isSavable()
        
        menuDescriptionTextView.layer.cornerRadius = 8
        menuDescriptionTextView.text = Constant.defaultMenuDescription
        menuDescriptionTextView.textColor = UIColor.lightGray
        
        menuDescriptionTextView.delegate = self
        menuNameTextField.delegate = self
        menuPriceTextField.delegate = self
        textFieldStock.delegate = self
        
        self.swipe(.right)

        setupObserver()
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
    
    func setupObserver() {
        addMenuVM.addMenuObservable
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .next(.success):
                    self.loadingView.stopAnimation()
                    Alert.show(type: .onOkayFunc(title: "Added", msg: "Succesfully added new menu", onOkay: { [weak self] in
                        self?.navigationController?.popViewController(animated: true)
                    }), viewController: self)
                default:
                    break
                }
            }.disposed(by: self.disposeBag)
    }
    
    func endTextFieldEditing() {
        menuNameTextField.endEditing(true)
        menuPriceTextField.endEditing(true)
        menuDescriptionTextView.endEditing(true)
        textFieldStock.endEditing(true)
    }
    
    func addMenu() {
        guard let menuName = menuNameTextField.text,
              let menuDescription = menuDescriptionTextView.text,
              let menuPrice = menuPriceTextField.text,
              let menuStock = textFieldStock.text
        else {
            menuNameTextField.text = ""
            menuDescriptionTextView.text = ""
            menuPriceTextField.text = ""
            textFieldStock.text = ""
            return
        }
        loadingView.startLoading()
        let description = menuDescription != Constant.defaultMenuDescription ? menuDescription : ""
        self.addMenuVM.addMenu(menuName: menuName, menuDescription: description, menuPrice: Int(menuPrice) ?? 0, menuStock: Int(menuStock) ?? 0, menuImage: self.menuImage)
    }
    
    func isSavable() -> Bool {
        guard let menuName = menuNameTextField.text?.trimmingCharacters(in: .whitespaces),
              let menuPrice = menuPriceTextField.text,
              let menuStock = textFieldStock.text,
              !menuName.isEmpty,
              !menuPrice.isEmpty,
              !menuStock.isEmpty,
              menuPrice.isNumberOnly(),
              menuStock.isNumberOnly()
        else {
            return false
        }
        return true
    }
}
