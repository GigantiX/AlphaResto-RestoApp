//
//  EditMenuViewModelImpl.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 19/06/24.
//

import Foundation
import RxSwift

enum EditMenuResult {
    case success
    case failure(Error)
}

protocol EditMenuViewModelInput {
    func editMenu(menuID: String, menuName: String?, menuDescription: String?, menuPrice: Int?, menuStock: Int?, menuImage: UIImage?, menuPath: String?)
    func deleteMenu(menuID: String, menuImagePath: String)
}

protocol EditMenuViewModelOutput {
    var editMenuObservable: PublishSubject<EditMenuResult> { get }
    var deleteMenuObservable: PublishSubject<EditMenuResult> { get }
    var disposeBag: DisposeBag { get }
}

protocol EditMenuViewModel: EditMenuViewModelInput, EditMenuViewModelOutput { }

final class EditMenuViewModelImpl: EditMenuViewModel {
    
    // MARK: - Use Case
    private let menuUseCase: MenuUseCase
    
    // MARK: - Output
    var editMenuObservable = PublishSubject<EditMenuResult>()
    var deleteMenuObservable = PublishSubject<EditMenuResult>()
    var disposeBag = DisposeBag()
    
    init(menuUseCase: MenuUseCase) {
        self.menuUseCase = menuUseCase
    }
}

extension EditMenuViewModelImpl {
    func editMenu(menuID: String, menuName: String?, menuDescription: String?, menuPrice: Int?, menuStock: Int?, menuImage: UIImage?, menuPath: String?) {
        menuUseCase.executeEditMenu(menuID: menuID, menuName: menuName, menuDescription: menuDescription, menuPrice: menuPrice, menuStock: menuStock, menuImage: menuImage, menuPath: menuPath)
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .completed:
                    self.editMenuObservable.onNext(.success)
                case .error(let error):
                    self.editMenuObservable.onNext(.failure(error))
                }
            }.disposed(by: self.disposeBag)
    }
    
    func deleteMenu(menuID: String, menuImagePath: String) {
        menuUseCase.executeDelete(menuID: menuID, menuImagePath: menuImagePath)
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .completed:
                    self.deleteMenuObservable.onNext(.success)
                case .error(let error):
                    self.deleteMenuObservable.onNext(.failure(error))
                }
            }.disposed(by: self.disposeBag)
    }
}
