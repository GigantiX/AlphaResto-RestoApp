//
//  RestoUseCase.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 14/06/24.
//

import Foundation
import RxSwift

protocol RestoUseCase {
    func executeLogin(email: String, password: String) -> Observable<String>
    func executeLogout() -> Completable
    func executeFetchProfile(restoID: String) -> Single<ProfileStoreModel>
    func executeUpdateProfile(close: String, is24h: Bool, open: String, address: String, desc: String, image: UIImage, telp: String) -> Completable
    func executeUpdateToken(restoID: String, token: String) -> Completable
    func executeUpdateTemporaryClose(restoID: String, isClose: Bool) -> Completable
}

final class RestoUseCaseImpl {
    
    private let restoRepository: RestoRepository
    
    init(restoRepository: RestoRepository) {
        self.restoRepository = restoRepository
    }
    
}

extension RestoUseCaseImpl: RestoUseCase {
    func executeUpdateProfile(close: String, is24h: Bool, open: String, address: String, desc: String, image: UIImage, telp: String) -> RxSwift.Completable {
        restoRepository.updateProfile(close: close, is24h: is24h, open: open, address: address, desc: desc, image: image, telp: telp)
    }
    
    func executeFetchProfile(restoID: String) -> RxSwift.Single<ProfileStoreModel> {
        restoRepository.fetchProfile(restoID: restoID)
    }
    
    func executeUpdateToken(restoID: String, token: String) -> Completable {
        restoRepository.updateToken(restoID: restoID, token: token)
    }
    
    func executeLogin(email: String, password: String) -> RxSwift.Observable<String> {
        restoRepository.login(email: email, password: password)
    }
    
    func executeLogout() -> RxSwift.Completable {
        restoRepository.logout()
    }
    
    func executeUpdateTemporaryClose(restoID: String, isClose: Bool) -> Completable {
        restoRepository.updateTemporaryClose(restoID: restoID, isClose: isClose)
    }
}
