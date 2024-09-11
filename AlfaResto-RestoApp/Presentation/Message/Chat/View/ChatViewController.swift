//
//  ChatViewController.swift
//  AlfaResto-RestoApp
//
//  Created by Axel Ganendra on 30/06/24.
//

import UIKit
import MessageKit
import RxSwift

class ChatViewController: MessagesViewController {
    
    private let dependencies = RestoAppDIContainer()
    
    lazy var viewModel = dependencies.makeChatViewModel()
    
    static var storyboardID: String {
        String(describing: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Chats"
        
        observeData()
        setupData()
        listenData()
        setupDisplayUI()
        becomeFirstResponder()
    }
    
    override var inputAccessoryView: UIView? {
        return messageInputBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    func currentSender() -> any MessageKit.SenderType {
        currentUser()
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> any MessageKit.MessageType {
        return viewModel.data[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        viewModel.data.count
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }
    
    func backgroundColor(for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return message.sender.senderId != UserDefaultManager.restoID ?? "" ? .semiWhite : .orange
    }
    
    func messageBottomLabelHeight(for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    
    func messageBottomLabelAttributedText(for message: any MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = message.sentDate.getTimeOnly()
        
        return NSAttributedString(string: dateString, attributes: [.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
}

private extension ChatViewController {
    
    @objc func backButtonTapped() {
      self.navigationController?.popViewController(animated: true)
    }
    
    func setupDisplayUI() {
        self.swipe(.right)
        
        messagesCollectionView.messagesDataSource = self
        
        setupLayout()
    }
    
    func setupLayout() {
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
    }
    
    func currentUser() -> UserMessage {
        return UserMessage(senderId: UserDefaultManager.restoID ?? "", displayName: "Alfa Resto")
    }
    
    func observeData() {
        viewModel.observeListener.observe(on: MainScheduler.instance).subscribe(onNext: { _ in
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToLastItem()
            
        }, onError: { error in
            debugPrint(error)
        }).disposed(by: viewModel.disposeBag)
        
        viewModel.observeChats.observe(on: MainScheduler.instance).subscribe(onNext: { _ in
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToLastItem()
        }, onError: { error in
            debugPrint(error)
        }).disposed(by: viewModel.disposeBag)
    }
    
    func setupData() {
        viewModel.fetchMessages()
    }
    
    func listenData() {
        viewModel.listenMessages()
    }
}
