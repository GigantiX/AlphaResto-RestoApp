//
//  RestoChatViewController.swift
//  AlfaResto-RestoApp
//
//  Created by Axel Ganendra on 01/07/24.
//

import UIKit
import MessageKit
import RxSwift
import IQKeyboardManagerSwift

class RestoChatViewController: UIViewController {
    
    @IBOutlet weak var viewMessageBar: UIView!
    @IBOutlet weak var textfieldMessage: UITextField!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var viewChatCell: UIView!
    
    private var chatVC: ChatViewController?
    
    var order: Order?
    
    static var storyboardID: String {
        String(describing: self)
    }
    
    override func viewDidLoad() {
        setupChatVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = false
    }
    
    @IBAction func onTapBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTapSendButton(_ sender: Any) {
        if textfieldMessage.text?.isEmpty == true {
            return
        } else {
            sendMessage(text: textfieldMessage.text ?? "")
            textfieldMessage.text = ""
        }
    }
}

private extension RestoChatViewController {
    func setupChatVC() {
        viewMessageBar.layer.cornerRadius = 30
        
        let storyboard = UIStoryboard(name: ChatViewController.storyboardID, bundle: nil)
        
        guard let chatVC = storyboard.instantiateViewController(withIdentifier: ChatViewController.storyboardID) as? ChatViewController else { return }
        
        labelName.text = order?.userName
        chatVC.viewModel.order = order
        self.chatVC = chatVC
        addChild(chatVC)
        chatVC.view.translatesAutoresizingMaskIntoConstraints = false
        viewChatCell.addSubview(chatVC.view)
        
        NSLayoutConstraint.activate([
            chatVC.view.topAnchor.constraint(equalTo: viewChatCell.topAnchor),
            chatVC.view.bottomAnchor.constraint(equalTo: viewChatCell.bottomAnchor),
            chatVC.view.leadingAnchor.constraint(equalTo: viewChatCell.leadingAnchor),
            chatVC.view.trailingAnchor.constraint(equalTo: viewChatCell.trailingAnchor)
        ])
        
        chatVC.didMove(toParent: self)
        chatVC.becomeFirstResponder()
    }
    
    func sendMessage(text: String) {
        let message = Chats(senderID: UserDefaultManager.restoID ?? "", senderName: "Alfa Resto", dateSend: Date(), message: text)
        chatVC?.viewModel.sendMessages(value: message)
    }
}


