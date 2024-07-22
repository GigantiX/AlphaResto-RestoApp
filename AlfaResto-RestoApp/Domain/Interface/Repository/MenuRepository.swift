//
//  MenuRepository.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 18/06/24.
//

import Foundation
import RxSwift

protocol MenuRepository {
    func getAllMenu(restoID: String) -> Observable<[Menu]?>
    func addMenu(restoID: String, menuName: String, menuDescription: String, menuPrice: Int, menuStock: Int, menuImage: UIImage) -> Completable
    func editMenu(menuID: String, menuName: String?, menuDescription: String?, menuPrice: Int?, menuStock: Int?, menuImage: UIImage?, menuPath: String?) -> Completable
    func deleteMenu(menuID: String, menuImagePath: String) -> Completable
}
