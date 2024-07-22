//
//  RestoRepository.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 14/06/24.
//

import Foundation
import RxSwift

protocol RestoRepository {
    func login(email: String, password: String) -> Observable<String>
    func logout() -> Completable
    func fetchProfile(restoID: String) -> Single<ProfileStoreModel>
    func updateProfile(close: String, is24h: Bool, open: String, address: String, desc: String, image: UIImage, telp: String) -> Completable
    func updateToken(restoID: String, token: String) -> Completable
    func updateTemporaryClose(restoID: String, isClose: Bool) -> Completable
}
