//
//  NotificationUseCase.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 26/06/24.
//

import Foundation
import RxSwift

protocol NotificationUseCase {
    func executePostNotification(tokenNotification: String, title: String, body: String, link: String?) -> Completable
}

final class NotificationUseCaseImpl {
    
    private let notificationRepository: NotificationRepository
    
    init(notificationRepository: NotificationRepository) {
        self.notificationRepository = notificationRepository
    }
    
}

extension NotificationUseCaseImpl: NotificationUseCase {
    func executePostNotification(tokenNotification: String, title: String, body: String, link: String?) -> RxSwift.Completable {
        notificationRepository.postNotification(tokenNotification: tokenNotification, title: title, body: body, link: link)
    }
}
