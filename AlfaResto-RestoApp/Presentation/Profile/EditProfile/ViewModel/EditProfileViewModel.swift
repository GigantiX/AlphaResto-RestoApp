//
//  EditProfileViewModel.swift
//  AlfaResto-RestoApp
//
//  Created by Axel Ganendra on 14/06/24.
//

import Foundation
import UIKit
import RxSwift

enum EditProfileResult {
    case success
    case failure(Error)
}

protocol EditProfileViewModelInput {
    func updateProfile(close: String, is24h: Bool, open: String, address: String, desc: String, image: UIImage, telp: String)
}

protocol EditProfileViewModelOutput {
    var disposeBag: DisposeBag { get }
    var status: PublishSubject<EditProfileResult> { get }
}

protocol EditProfileViewModel: EditProfileViewModelInput, EditProfileViewModelOutput { }

final class EditProfileViewModelImpl: EditProfileViewModel {
    
    let restoUseCase: RestoUseCase
    
    var status = PublishSubject<EditProfileResult>()
    var disposeBag = DisposeBag()
    
    init(restoUseCase: RestoUseCase) {
        self.restoUseCase = restoUseCase
    }
    
    func updateProfile(close: String, is24h: Bool, open: String, address: String, desc: String, image: UIImage, telp: String) {
        restoUseCase.executeUpdateProfile(close: close, is24h: is24h, open: open, address: address, desc: desc, image: image, telp: telp)
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .completed:
                    self.status.onNext(.success)
                case .error(let error):
                    self.status.onNext(.failure(error))
                }
            }
            .disposed(by: disposeBag)
    }
    
    
}
