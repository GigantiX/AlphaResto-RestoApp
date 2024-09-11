//
//  LoginViewModel.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 13/06/24.
//

import Foundation
import RxSwift
import FirebaseMessaging

enum LoginResult {
    case success(String)
    case failure(Error)
}

protocol LoginViewModelInput {
    func login(email: String, password: String) throws
    func updateFCMToken(token: String)
}

protocol LoginViewModelOutput { 
    var loginObservable: PublishSubject<LoginResult> { get }
    var updateTokenObservable: PublishSubject<LoginResult> { get }
}

protocol LoginViewModel: LoginViewModelInput, LoginViewModelOutput { }

final class LoginViewModelImpl: LoginViewModel {
    
    // MARK: - Use Case
    private let restoUseCase: RestoUseCase
    private let fcmTokenHandler: FCMTokenHandler
    
    // MARK: - Output
    var loginObservable = PublishSubject<LoginResult>()
    var updateTokenObservable = PublishSubject<LoginResult>()
    
    private let disposeBag = DisposeBag()
    
    init(restoUseCase: RestoUseCase,
         fcmTokenHandler: FCMTokenHandler
    ) {
        self.restoUseCase = restoUseCase
        self.fcmTokenHandler = fcmTokenHandler
    }
    
}

extension LoginViewModelImpl {
    func updateFCMToken(token: String) {
        fcmTokenHandler.updateTokenFCMToFirestore(with: token)
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .error(let error):
                    self.updateTokenObservable.onNext(.failure(error))
                case .completed:
                    self.updateTokenObservable.onNext(.success(""))
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    func login(email: String, password: String) throws {
        guard !email.isEmpty, !password.isEmpty else {
            throw AppError.texiFieldIsEmpty
        }
        restoUseCase.executeLogin(email: email, password: password)
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .next(let uid):
                    self.loginObservable.onNext(.success(uid))
                case .error(let error):
                    self.loginObservable.onNext(.failure(error))
                default:
                    break
                }
            }.disposed(by: self.disposeBag)
    }
}
