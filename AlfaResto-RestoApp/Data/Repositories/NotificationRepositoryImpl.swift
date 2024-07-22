//
//  NotificationRepositoryImpl.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 26/06/24.
//

import Foundation
import RxSwift

final class NotificationRepositoryImpl {
    
    private let dataTranseferService: DataTransferService
    
    var disposeBag = DisposeBag()
    
    init(dataTranseferService: DataTransferService) {
        self.dataTranseferService = dataTranseferService
    }
    
}

extension NotificationRepositoryImpl: NotificationRepository {
    
    func postNotification(tokenNotification: String, title: String, body: String, link: String?) -> RxSwift.Completable {
        return Completable.create { [weak self] completable in
            guard let self else { return Disposables.create() }
            
            let endpoint = APIEndpoints.postNotification(tokenNotification: tokenNotification, title: title, body: body, link: link)
            self.dataTranseferService.requestNotif(with: endpoint)
                .subscribe { event in
                    switch event {
                    case .completed:
                        completable(.completed)
                    case .error(let error):
                        completable(.error(error))
                    }
                }
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}
