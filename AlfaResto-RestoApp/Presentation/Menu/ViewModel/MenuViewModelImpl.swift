//
//  MenuViewModel.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 17/06/24.
//

import Foundation
import RxSwift

enum MenuResult {
    case success
    case failure(Error)
}

protocol MenuViewModelInput { 
    func getAllMenu()
}

protocol MenuViewModelOutput { 
    var menus: [Menu]? { get set }
    var menuObservable: PublishSubject<MenuResult> { get }
    var disposeBag: DisposeBag { get }
}

protocol MenuViewModel: MenuViewModelInput, MenuViewModelOutput { }

final class MenuViewModelImpl: MenuViewModel {
    
    // MARK: - UseCase
    private let menuUseCase: MenuUseCase
    
    // MARK: - Output
    var menus: [Menu]?
    var menuObservable = PublishSubject<MenuResult>()
    var disposeBag = DisposeBag()
    
    init(menuUseCase: MenuUseCase) {
        self.menuUseCase = menuUseCase
    }
    
}

extension MenuViewModelImpl {
    func getAllMenu() {
        menuUseCase.getAllMenu()
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .next(let menus):
                    self.menus = menus
                    self.menuObservable.onNext(.success)
                case .error(let error):
                    self.menuObservable.onNext(.failure(error))
                default:
                    break
                }
            }.disposed(by: self.disposeBag)
    }
}
