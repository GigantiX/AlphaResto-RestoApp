//
//  AddMenuViewModelImpl.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 18/06/24.
//

import Foundation
import RxSwift

enum AddMenuResult {
    case success
    case failure(Error)
}

protocol AddMenuViewModelInput {
    func addMenu(menuName: String, menuDescription: String, menuPrice: Int, menuStock: Int, menuImage: UIImage)
}

protocol AddMenuViewModelOutput {
    var addMenuObservable: PublishSubject<AddMenuResult> { get }
    var disposeBag: DisposeBag { get }
    var imagePath: String { get set }
}

protocol AddMenuViewModel: AddMenuViewModelInput, AddMenuViewModelOutput { }

final class AddMenuViewModelImpl: AddMenuViewModel {
    
    // MARK: - UseCase
    private let menuUseCase: MenuUseCase
    
    // MARK: - Output
    var addMenuObservable = PublishSubject<AddMenuResult>()
    var disposeBag = DisposeBag()
    var imagePath = ""
    
    init(menuUseCase: MenuUseCase) {
        self.menuUseCase = menuUseCase
    }
    
}

extension AddMenuViewModelImpl {
    func addMenu(menuName: String, menuDescription: String, menuPrice: Int, menuStock: Int, menuImage: UIImage) {
        menuUseCase.executeAddMenu(restoID: UserDefaultManager.restoID ?? "", menuName: menuName, menuDescription: menuDescription, menuPrice: menuPrice, menuStock: menuStock, menuImage: menuImage).subscribe { [weak self] event in
            guard let self else { return }
            switch event {
            case .completed:
                self.addMenuObservable.onNext(.success)
            case .error(let error):
                self.addMenuObservable.onNext(.failure(error))
            }
        }
        .disposed(by: self.disposeBag)
    }
}
