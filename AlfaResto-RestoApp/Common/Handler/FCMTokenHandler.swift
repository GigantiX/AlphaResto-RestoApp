//
//  FCMTokenHandler.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 27/06/24.
//

import Foundation
import RxSwift
import FirebaseMessaging

protocol FCMTokenHandler {
    func updateTokenFCMToFirestore(with newToken: String) -> Completable
    func invalidateToken()
}

final class FCMTokenHandlerImpl {
    
    private let restoUseCase: RestoUseCase
    
    init(restoUseCase: RestoUseCase) {
        self.restoUseCase = restoUseCase
    }
    
}

extension FCMTokenHandlerImpl: FCMTokenHandler {
    func updateTokenFCMToFirestore(with newToken: String) -> Completable {
        restoUseCase.executeUpdateToken(restoID: UserDefaultManager.restoID ?? "", token: newToken)
    }
    
    func invalidateToken() {
        Messaging.messaging().deleteToken { error in
            if let error {
                debugPrint("Error deleting FCM token: \(error.localizedDescription)")
                return
            }
        }
    }
}
