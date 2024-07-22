//
//  MenuUseCase.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 18/06/24.
//

import Foundation
import RxSwift

protocol MenuUseCase {
    func executeGetAllMenu(restoID: String) -> Observable<[Menu]?>
    func executeAddMenu(restoID: String, menuName: String, menuDescription: String, menuPrice: Int, menuStock: Int, menuImage: UIImage) -> Completable
    func executeEditMenu(menuID: String, menuName: String?, menuDescription: String?, menuPrice: Int?, menuStock: Int?, menuImage: UIImage?, menuPath: String?) -> Completable
    func executeDelete(menuID: String, menuImagePath: String) -> Completable
}

final class MenuUseCaseImpl {
    private let menuRepository: MenuRepository
    
    init(menuRepository: MenuRepository) {
        self.menuRepository = menuRepository
    }
}

extension MenuUseCaseImpl: MenuUseCase {
    
    func executeGetAllMenu(restoID: String) -> RxSwift.Observable<[Menu]?> {
        menuRepository.getAllMenu(restoID: restoID)
    }
    
    func executeAddMenu(restoID: String, menuName: String, menuDescription: String, menuPrice: Int, menuStock: Int, menuImage: UIImage) -> RxSwift.Completable {
        menuRepository.addMenu(restoID: restoID, menuName: menuName, menuDescription: menuDescription, menuPrice: menuPrice, menuStock: menuStock, menuImage: menuImage)
    }
    
    func executeEditMenu(menuID: String, menuName: String?, menuDescription: String?, menuPrice: Int?, menuStock: Int?, menuImage: UIImage?, menuPath: String?) -> RxSwift.Completable {
        menuRepository.editMenu(menuID: menuID, menuName: menuName, menuDescription: menuDescription, menuPrice: menuPrice, menuStock: menuStock, menuImage: menuImage, menuPath: menuPath)
    }
    
    func executeDelete(menuID: String, menuImagePath: String) -> RxSwift.Completable {
        menuRepository.deleteMenu(menuID: menuID, menuImagePath: menuImagePath)
    }
}
