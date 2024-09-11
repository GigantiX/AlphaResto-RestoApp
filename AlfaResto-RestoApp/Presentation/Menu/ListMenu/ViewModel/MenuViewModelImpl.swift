//
//  MenuViewModel.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 17/06/24.
//

import Foundation
import RxSwift

enum ListMenuResult {
    case success
    case failure(Error)
}

protocol ListMenuViewModelInput {
    func getAllMenu()
}

protocol ListMenuViewModelOutput {
    var menus: [Menu]? { get set }
    var menuObservable: PublishSubject<ListMenuResult> { get }
    var disposeBag: DisposeBag { get }
}

protocol ListMenuViewModel: ListMenuViewModelInput, ListMenuViewModelOutput { }

final class ListMenuViewModelImpl: ListMenuViewModel {
    
    // MARK: - UseCase
    private let menuUseCase: MenuUseCase
    
    // MARK: - Output
    var menus: [Menu]?
    var menuObservable = PublishSubject<ListMenuResult>()
    var disposeBag = DisposeBag()
    
    init(menuUseCase: MenuUseCase) {
        self.menuUseCase = menuUseCase
    }
    
}

extension ListMenuViewModelImpl {
    func getAllMenu() {
        menuUseCase.executeGetAllMenu(restoID: UserDefaultManager.restoID ?? "")
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
