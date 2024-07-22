//
//  EditMenuViewController.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 19/06/24.
//

import UIKit
import RxSwift
import IQKeyboardManagerSwift

final class EditMenuViewController: UIViewController {
    
    @IBOutlet weak var textFieldStock: UITextField!
    @IBOutlet private weak var menuNameTextField: UITextField!
    @IBOutlet private weak var imageButton: UIImageView!
    @IBOutlet private weak var menuPriceTextField: UITextField!
    @IBOutlet private weak var menuDescriptionTextView: UITextView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    
    private let dependencies = RestoAppDIContainer()
    private let disposeBag = DisposeBag()
    private let loadingView = LoadingView(frame: .zero)
    private lazy var editMenuVM = dependencies.makeEditMenuViewModel()
    
    private var menuImagePath = ""
    private var menuImage: UIImage?
    var menu: Menu?
    
    static var storyboardID: String {
        String(describing: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isSaveButtonEnable()
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
        editMenu()
    }
    
    @IBAction func onTapDeleteItem(_ sender: Any) {
        deleteItem()
    }
}

extension EditMenuViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            imageButton.image = selectedImage
            self.menuImage = selectedImage
            isSaveButtonEnable()
        }
    
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension EditMenuViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        isSaveButtonEnable()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = menu?.menuDescription
            textView.textColor = UIColor.lightGray
        }
    }
}

extension EditMenuViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        isSaveButtonEnable()
    }
}

private extension EditMenuViewController {
    func setup() {
        setupLoadingView()
        menuNameTextField.delegate = self
        menuPriceTextField.delegate = self
        textFieldStock.delegate = self
        
        textFieldStock.text = "\(menu?.stock ?? 0)"
        menuNameTextField.text = menu?.menuName
        menuPriceTextField.text = "\(menu?.menuPrice ?? 0)"
        menuDescriptionTextView.text = menu?.menuDescription
        imageButton.getImage(link: menu?.menuImage ?? "")
        
        menuDescriptionTextView.layer.cornerRadius = 8
        
        menuDescriptionTextView.delegate = self
        
        saveButton.isEnabled = isSavable()
        
        setupObserver()
        self.swipe(.right)
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
        editMenuVM.editMenuObservable
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .next(.success):
                    self.loadingView.stopAnimation()
                    Alert.show(type: .onOkayFunc(title: "Edited", msg: "Succesfully edited new menu", onOkay: { [weak self] in
                        self?.navigationController?.popViewController(animated: true)
                    }), viewController: self)
                default:
                    break
                }
            }.disposed(by: self.disposeBag)
        
        editMenuVM.deleteMenuObservable
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .next(.success):
                    self.loadingView.stopAnimation()
                    Alert.show(type: .onOkayFunc(title: "Deleted", msg: "Succesfully edited new menu", onOkay: { [weak self] in
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
    
    func editMenu() {
        loadingView.startLoading()
        editMenuVM.editMenu(menuID: menu?.id ?? "", menuName: menuNameTextField.text, menuDescription: menuDescriptionTextView.text, menuPrice: Int(menuPriceTextField.text ?? ""), menuStock: Int(textFieldStock.text ?? ""), menuImage: self.menuImage, menuPath: menu?.menuPath)
    }
    
    func isSavable() -> Bool {
        if let menuName = menuNameTextField.text,
           let menuPrice = menuPriceTextField.text,
           let menuDescription = menuDescriptionTextView.text,
           let menuStock = textFieldStock.text,
           menuName != menu?.menuName || menuPrice != "\(menu?.menuPrice ?? 0)" || menuDescription != menu?.menuDescription || self.menuImage != nil || menuStock != "\(menu?.stock ?? 0)",
           !menuName.isEmptyContainsWhitespace(),
           !menuPrice.isEmptyContainsWhitespace(),
           !menuStock.isEmptyContainsWhitespace(),
           menuPrice.isNumberOnly(),
           menuStock.isNumberOnly()
        {
            return true
        }
        return false
    }
    
    func isSaveButtonEnable() {
        saveButton.isEnabled = isSavable()
    }
    
    func deleteItem() {
        Alert.show(type: .destructive(title: "Delete Menu", msg: "Are you sure want to delete this menu?", destructiveTitle: "Delete", destructiveAction: { [weak self] in
            self?.loadingView.startLoading()
            self?.editMenuVM.deleteMenu(menuID: self?.menu?.id ?? "", menuImagePath: self?.menu?.menuPath ?? "")
            self?.navigationController?.popViewController(animated: true)
        }), viewController: self)
    }
}

