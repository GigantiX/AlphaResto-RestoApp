//
//  NotificationRepository.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 26/06/24.
//

import Foundation
import RxSwift

protocol NotificationRepository {
    var disposeBag: DisposeBag { get }
    func postNotification(tokenNotification: String, title: String, body: String, link: String?) -> Completable
}
