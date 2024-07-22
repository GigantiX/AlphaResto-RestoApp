//
//  ProfileViewModel.swift
//  AlfaResto-RestoApp
//
//  Created by Axel Ganendra on 14/06/24.
//

import Foundation
import RxSwift

enum ProfileResult {
    case success
    case failure(Error)
}

protocol ProfileViewModelInput {
    func fetchProfile()
    func updateTemporaryClose(isClose: Bool)
    func logoutAccount() -> Completable
    func invalidateFCMToken()
    func updateTokenFCM(token: String)
}

protocol ProfileViewModelOutput {
    var data: ProfileStoreModel? { get set }
    var status: PublishSubject<ProfileStoreModel> { get }
    var updateTokenObservable: PublishSubject<ProfileResult> { get }
    var updateTemporaryCloseObservable: PublishSubject<ProfileResult> { get }
    var disposeBag: DisposeBag { get }
}

protocol ProfileViewModel: ProfileViewModelInput, ProfileViewModelOutput { }

final class ProfileViewModelImpl: ProfileViewModel {
    
    private let restoUseCase: RestoUseCase
    private let fcmTokenHandler: FCMTokenHandler
    
    var disposeBag = DisposeBag()
    var status: PublishSubject<ProfileStoreModel> = PublishSubject()
    var updateTemporaryCloseObservable = PublishSubject<ProfileResult>()
    var updateTokenObservable = PublishSubject<ProfileResult>()
    var data: ProfileStoreModel?
    
    init(restoUseCase: RestoUseCase,
         fcmTokenHanlder: FCMTokenHandler
    ) {
        self.restoUseCase = restoUseCase
        self.fcmTokenHandler = fcmTokenHanlder
    }
    
    func updateTemporaryClose(isClose: Bool) {
        restoUseCase.executeUpdateTemporaryClose(restoID: UserDefaultManager.restoID ?? "", isClose: isClose)
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .error(let error):
                    self.updateTemporaryCloseObservable.onNext(.failure(error))
                case .completed:
                    self.fetchProfile()
                    self.updateTemporaryCloseObservable.onNext(.success)
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    func fetchProfile() {
        restoUseCase.executeFetchProfile(restoID: UserDefaultManager.restoID ?? "")
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .success(let result):
                    self.status.onNext(result)
                    self.data = result
                case .failure(let error):
                    debugPrint(error)
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    func logoutAccount() -> RxSwift.Completable {
        return Completable.create { completable in
            self.restoUseCase.executeLogout().subscribe(onCompleted: {
                completable(.completed)
            }, onError: { error in
                completable(.error(error))
            }).disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    func updateTokenFCM(token: String) {
        fcmTokenHandler.updateTokenFCMToFirestore(with: token)
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .error(let error):
                    self.updateTokenObservable.onNext(.failure(error))
                case .completed:
                    self.updateTokenObservable.onNext(.success)
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    func invalidateFCMToken() {
        fcmTokenHandler.invalidateToken()
    }
    
}
