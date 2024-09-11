//
//  FirestoreDatabase.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 14/06/24.
//

import Foundation
import FirebaseAuth
import RxSwift

protocol AuthenticationServices {
    func register(email: String, password: String) -> Completable
    func login(email: String, password: String) -> Observable<String>
    func logout() -> Completable
}

final class AuthenticationServicesImpl {
    init() {}
}

extension AuthenticationServicesImpl: AuthenticationServices {
    // Just in case using this function in the future
    func register(email: String, password: String) -> RxSwift.Completable {
        return Completable.create { completable in
            Task {
                do {
                    let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
                    let _ = AuthDataResultModel(user: authDataResult.user)
                    completable(.completed)
                } catch {
                    completable(.error(AuthenticationError.userAlreadyExists))
                }
            }
            return Disposables.create()
        }
    }
    
    func login(email: String, password: String) -> RxSwift.Observable<String> {
        return Observable.create { observer in
            Task {
                do {
                    let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
                    observer.onNext(authDataResult.user.uid)
                    observer.onCompleted()
                } catch {
                    observer.onError(AuthenticationError.invalidData)
                }
            }
            return Disposables.create()
        }
    }
    
    func logout() -> RxSwift.Completable {
        return Completable.create { completable in
            do {
                try Auth.auth().signOut()
                completable(.completed)
            } catch {
                completable(.error(AuthenticationError.logoutError))
            }
            return Disposables.create()
        }
    }
    
}
