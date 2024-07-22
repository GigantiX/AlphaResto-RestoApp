//
//  ChatUseCase.swift
//  AlfaResto-RestoApp
//
//  Created by Axel Ganendra on 01/07/24.
//

import Foundation
import RxSwift

protocol ChatUseCase {
    func executeListenChat(orderID: String) -> Observable<[Message]>
    func executeFetchChats(orderID: String) -> Single<[Message]>
    func executeSendMessage(message: Chats, id: String) -> Completable
}

final class ChatUseCaseImpl {
    private let chatRepository: ChatRepository
    
    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
    }
}

extension ChatUseCaseImpl: ChatUseCase {
    
    func executeListenChat(orderID: String) -> RxSwift.Observable<[Message]> {
        chatRepository.listenerChats(orderID: orderID)
    }
    
    func executeFetchChats(orderID: String) -> RxSwift.Single<[Message]> {
        chatRepository.fetchChatsIn(orderID: orderID)
    }
    
    func executeSendMessage(message: Chats, id: String) -> RxSwift.Completable {
        chatRepository.sendChatTo(message: message, id: id)
    }
}
