//
//  ChatRepository.swift
//  AlfaResto-RestoApp
//
//  Created by Axel Ganendra on 01/07/24.
//

import Foundation
import RxSwift

protocol ChatRepository {
    func listenerChats(orderID: String) -> Observable<[Message]>
    func fetchChatsIn(orderID: String) -> Single<[Message]>
    func sendChatTo(message: Chats, id: String) -> Completable
}
