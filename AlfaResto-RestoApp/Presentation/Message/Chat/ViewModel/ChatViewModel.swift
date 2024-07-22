//
//  ChatViewModel.swift
//  AlfaResto-RestoApp
//
//  Created by Axel Ganendra on 30/06/24.
//

import Foundation
import RxSwift

protocol ChatViewModelInput {
    func fetchMessages()
    func listenMessages()
    func sendMessages(value: Chats)
}

protocol ChatViewModelOutput {
    var disposeBag: DisposeBag { get }
    var order: Order? { get set }
    var data: [Message] { get set }
    var userToken: String? { get set }
    var userID: String { get set }
    var observeChats: PublishSubject<FetchResult> { get }
    var observeSends: PublishSubject<FetchResult> { get }
    var observeListener: PublishSubject<FetchResult> { get }
}

protocol ChatViewModel: ChatViewModelInput, ChatViewModelOutput { }

class ChatViewModelImpl: ChatViewModel {
    
    private let chatUseCase: ChatUseCase
    private let notifUseCase: NotificationUseCase
    private let orderUseCase: OrderUseCase
    
    var disposeBag = DisposeBag()
    var order: Order?
    var userToken: String?
    var data: [Message] = []
    var userID: String = ""
    var observeChats: PublishSubject<FetchResult> = PublishSubject()
    var observeSends: PublishSubject<FetchResult> = PublishSubject()
    var observeListener: PublishSubject<FetchResult> = PublishSubject()
    
    init(chatUseCase: ChatUseCase, notifUseCase: NotificationUseCase, orderUseCase: OrderUseCase) {
        self.chatUseCase = chatUseCase
        self.notifUseCase = notifUseCase
        self.orderUseCase = orderUseCase
    }
    
    func listenMessages() {
        chatUseCase.executeListenChat(orderID: order?.id ?? "").subscribe(onNext: { [weak self] result in
            guard let self else { return }
            self.data = result
            self.getUserToken()
            self.observeListener.onNext(.success)
        }, onError: { error in
            self.observeListener.onError(error)
        }).disposed(by: disposeBag)
    }
    
    func fetchMessages() {
        chatUseCase.executeFetchChats(orderID: order?.id ?? "").subscribe(onSuccess: { result in
            self.data = result
            self.observeChats.onNext(.success)
        }, onFailure: { error in
            self.observeChats.onError(error)
        }).disposed(by: disposeBag)
    }
    
    func sendMessages(value: Chats) {
        chatUseCase.executeSendMessage(message: value, id: order?.id ?? "").subscribe(onCompleted: {
            self.sendNotification(title: "AlfaResto Driver", body: value.message)
            self.observeSends.onNext(.success)
        }, onError: { error in
            self.observeSends.onError(error)
        }).disposed(by: disposeBag)
    }
    
    func getUserToken() {
        orderUseCase.executeGetUserToken(userID: order?.userID ?? "")
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .next(let token):
                    self.userToken = token
                default:
                    break
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    func sendNotification(title: String, body: String) {
        notifUseCase.executePostNotification(tokenNotification: userToken ?? "", title: title, body: body, link: Constant.chatDeepLinkUrlAndroid + (order?.id ?? "")).subscribe(onError: { error in
            debugPrint(error)
        }).disposed(by: disposeBag)
    }
}
