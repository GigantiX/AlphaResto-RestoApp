//
//  EditProfileViewController.swift
//  AlfaResto-RestoApp
//
//  Created by Axel Ganendra on 14/06/24.
//

import UIKit
import Lottie
import IQKeyboardManagerSwift

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var switch24Hours: UISwitch!
    @IBOutlet weak var imageStore: UIImageView!
    @IBOutlet weak var textFieldCloseHour: UITextField!
    @IBOutlet weak var textFieldOpenHour: UITextField!
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    @IBOutlet weak var textViewAddress: UITextView!
    @IBOutlet weak var textViewDescription: UITextView!
    @IBOutlet weak var saveProfileButton: UIButton!
    
    private let dependency = RestoAppDIContainer()
    private let loadingView = LoadingView(frame: .zero)
    
    private var viewModel: EditProfileViewModel?
    private var activeTextfield: UITextField?
    
    private lazy var timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        
        picker.datePickerMode = .time
        picker.locale = Locale(identifier: "en_GB")
        picker.preferredDatePickerStyle = .wheels
        
        return picker
    }()
    
    var data: ProfileStoreModel?
    var image: UIImage = UIImage()
    
    static var storyboardID: String {
        String(describing: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endTextFieldEditing()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = dependency.makeEditProfileViewModel()
        
        setupDisplay()
        setupTextField()
        setupObservable()
        setupLoadingView()
        setupTimePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = false
    }
    
    @IBAction func toogle24Hours(_ sender: UISwitch) {
        setupToogle(status: sender.isOn)
    }
    
    @IBAction func onTapBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTapAddImage(_ sender: Any) {
        showImagePicker()
    }
    
    @IBAction func onTapSaveProfile(_ sender: Any) {
        loadingView.startLoading()
        updateProfile()
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        isSaveButtonEnable()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == textFieldPhoneNumber {
            let isAllowed = string.isNumberOnly() && setMaxInput(in: textField, range: range, string: string, maxLength: 13)
            return isAllowed
        }
        return true
    }
}

extension EditProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        isSaveButtonEnable()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextfield = textField
        
        guard let data else { return }
        
        if textField == textFieldOpenHour {
            timePicker.date = data.openingTime.stringToDate(format: .hourAndMinute)
        }
        if textField == textFieldCloseHour {
            timePicker.date = data.closingTime.stringToDate(format: .hourAndMinute)
        }
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            image = selectedImage
            imageStore.image = selectedImage
            isSaveButtonEnable()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

private extension EditProfileViewController {
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
    
    func setupTextField() {
        isSaveButtonEnable()
        self.swipe(.right)
        textFieldOpenHour.delegate = self
        textFieldCloseHour.delegate = self
        textFieldPhoneNumber.delegate = self
        textViewAddress.delegate = self
        textViewDescription.delegate = self
    }
    
    func setNumberOnly(value: String) -> Bool {
        let allowedChar = "0987654321"
        let allowedChrSet = CharacterSet(charactersIn: allowedChar)
        let typedChrstIn = CharacterSet(charactersIn: value)
        let numbers = allowedChrSet.isSuperset(of: typedChrstIn)
        return numbers
    }
    
    func setMaxInput(in textField: UITextField, range: NSRange, string: String, maxLength: Int) -> Bool {
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return prospectiveText.count <= maxLength
    }
    
    func setupToogle(status: Bool) {
        isSaveButtonEnable()
        textFieldOpenHour.isEnabled = status != true
        textFieldCloseHour.isEnabled = status != true
        
        if status {
            textFieldOpenHour.text = ""
            textFieldCloseHour.text = ""
        } else {
            textFieldOpenHour.text = data?.openingTime
            textFieldCloseHour.text = data?.closingTime
        }
    }
    
    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func setupDisplay() {
        guard let data else { return }
        imageStore.getImage(link: data.image)
        switch24Hours.setOn(data.is24hours, animated: true)
        textFieldOpenHour.text = data.openingTime
        textFieldCloseHour.text = data.closingTime
        textFieldPhoneNumber.text = data.phoneNumber
        textViewAddress.text = data.address
        textViewDescription.text = data.description
        
        setupToogle(status: data.is24hours)
    }
    
    func updateProfile() {
        viewModel?.updateProfile(close: textFieldCloseHour.text ?? "", is24h: switch24Hours.isOn, open: textFieldOpenHour.text ?? "", address: textViewAddress.text ?? "", desc: textViewDescription.text ?? "", image: image, telp: textFieldPhoneNumber.text ?? "")
    }
    
    func setupObservable() {
        guard let viewModel else { return }
        viewModel.status
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .next(.success):
                    self.loadingView.stopAnimation()
                    Alert.show(type: .onOkayFunc(title: "Edit Data Successfully", msg: "Your profile data has been updated!", onOkay: {
                        self.navigationController?.popViewController(animated: true)
                    }), viewController: self)
                case .next(.failure(let error)):
                    self.loadingView.stopAnimation()
                    Alert.show(type: .standard(title: "Error update data", msg: "\(error.localizedDescription)"), viewController: self)
                default:
                    break
                }
            }
            .disposed(by: viewModel.disposeBag)
    }
    
    func isSavable() -> Bool {
        if let phoneNumber = textFieldPhoneNumber.text,
           let address = textViewAddress.text,
           let description = textViewDescription.text,
           address != data?.address || phoneNumber != data?.phoneNumber || self.image != UIImage() || switch24Hours.isOn != data?.is24hours || description != data?.description || validateOpenHours(),
           !phoneNumber.isEmptyContainsWhitespace(),
           !address.isEmptyContainsWhitespace()
        {
            return true
        }
        return false
    }
    
    func validateOpenHours() -> Bool {
        guard let data else { return false }
        if data.is24hours == false {
            if let openHour = textFieldOpenHour.text,
               let closeHour = textFieldCloseHour.text,
               !openHour.isEmptyContainsWhitespace() || !closeHour.isEmptyContainsWhitespace(),
               openHour != data.openingTime || closeHour != data.closingTime
            {
                return true
            }
        }
        return false
    }
    
    func isSaveButtonEnable() {
        saveProfileButton.isEnabled = isSavable()
    }
    
    func endTextFieldEditing() {
        textViewAddress.endEditing(true)
        textFieldOpenHour.endEditing(true)
        textViewDescription.endEditing(true)
        textFieldPhoneNumber.endEditing(true)
        textFieldCloseHour.endEditing(true)
    }
    
    func setupTimePicker() {
        textFieldOpenHour.inputView = timePicker
        textFieldCloseHour.inputView = timePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        
        textFieldOpenHour.inputAccessoryView = toolbar
        textFieldCloseHour.inputAccessoryView = toolbar
    }
    
    @objc func doneTapped() {
        if let activeTextfield {
            let dateString = timePicker.date.dateToString(to: .hourAndMinute)
            activeTextfield.text = dateString
            isSaveButtonEnable()
        }
        view.endEditing(true)
    }
}

