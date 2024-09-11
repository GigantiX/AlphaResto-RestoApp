//
//  ChatsRepositoryImpl.swift
//  AlfaResto-RestoApp
//
//  Created by Axel Ganendra on 29/06/24.
//

import Foundation
import RxSwift
import FirebaseFirestore

final class ChatsRepositoryImpl: ChatRepository {
    private let disposeBag = DisposeBag()
    
    func listenerChats(orderID: String) -> Observable<[Message]> {
        return Observable.create { observer in
            let references = FirestoreReferences.getChatsCollectionReferences(orderID: orderID).order(by: "date_send", descending: false)
            
            let listener = references.addSnapshotListener { snapshot, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    observer.onNext([])
                    return
                }
                
                do {
                    let chats: [Chats] = try documents.map { try $0.data(as: Chats.self) }
                    let messages = chats.map { MessageMappers.mapChatToMessage(chat: $0) }
                    observer.onNext(messages)
                } catch {
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                listener.remove()
            }
        }
    }
    
    func fetchChatsIn(orderID: String) -> Single<[Message]> {
            return Single.create { single in
                let references = FirestoreReferences.getChatsCollectionReferences(orderID: orderID).order(by: "date_send", descending: false)
                
                Task {
                    do {
                        let result: [Chats] = try await references.getAllDocuments(as: Chats.self) ?? []
                        let messages = result.map { MessageMappers.mapChatToMessage(chat: $0) }
                        single(.success(messages))
                    } catch {
                        single(.failure(error))
                    }
                }
                
                return Disposables.create()
            }
        }
    
    func sendChatTo(message: Chats, id: String) -> Completable {
        return Completable.create { complete in
            let references = FirestoreReferences.getChatsCollectionReferences(orderID: id)
            
            do {
                let chat = try Firestore.Encoder().encode(message)
                
                references.addDocument(data: chat) { error in
                    if let error {
                        complete(.error(error))
                    } else {
                        complete(.completed)
                    }
                }
            } catch {
                complete(.error(error))
            }
            return Disposables.create()
        }
    }
}
