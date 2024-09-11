//
//  MenuRepositoryImpl.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 18/06/24.
//

import Foundation
import RxSwift

final class MenuRepositoryImpl {
    
    private let firestoreServices: FirestoreServices
    private let firebaseStorageServices: FirebaseStorageServices
    private let disposeBag = DisposeBag()
    
    init(firestoreServices: FirestoreServices,
         firebaseStorageServices: FirebaseStorageServices
    ) {
        self.firestoreServices = firestoreServices
        self.firebaseStorageServices = firebaseStorageServices
    }
    
}

extension MenuRepositoryImpl: MenuRepository {
    
    func getAllMenu(restoID: String) -> RxSwift.Observable<[Menu]?> {
        return Observable.create { observer in
            let firestoreReferences = FirestoreReferences.getMenuCollectionReferences()
            let result = firestoreReferences.whereField(Menu.CodingKeys.restoID.rawValue, isEqualTo: restoID).addSnapshotListener { snapshot, error in
                if let error {
                    observer.onError(AppError.errorFetchData)
                    return
                }
                
                if let snapshot {
                    do {
                        let result = try snapshot.getAllDocuments(as: Menu.self)
                        observer.onNext(result)
                    } catch {
                        observer.onError(AppError.unexpectedError)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    func addMenu(restoID: String, menuName: String, menuDescription: String, menuPrice: Int, menuStock: Int, menuImage: UIImage) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self else { return Disposables.create() }
            
            let id = UUID().uuidString + ".jpg"
            
            self.uploadImage(id: id, menuImage: menuImage, type: .menu)
                .subscribe(onSuccess: { [weak self] imageUrl in
                    guard let self else { return }
                    do {
                        try self.addMenuToFirestore(restoID: restoID, menuName: menuName, menuDescription: menuDescription, menuPrice: menuPrice, menuStock: menuStock, imageUrl: imageUrl, menuPath: id)
                        completable(.completed)
                    } catch {
                        completable(.error(AppError.unexpectedError))
                    }
                }, onFailure: { error in
                    completable(.error(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func editMenu(menuID: String, menuName: String?, menuDescription: String?, menuPrice: Int?, menuStock: Int?, menuImage: UIImage?, menuPath: String?) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self else { return Disposables.create() }
            
            let firestoreReferences = FirestoreReferences.getMenuDocumentReferences(menuID: menuID)
            let id = UUID().uuidString + ".jpg"
            var updatedData: [String: Any] = [:]
            
            if let menuImage {
                self.deleteMenuImageFromStorage(path: menuPath ?? "")
            }
            
            generalUpdatedData(&updatedData, menuName: menuName, menuDescription: menuDescription, menuPrice: menuPrice, menuStock: menuStock)
            
            let imageUploadObservable = self.getImageUploadObservable(menuImage: menuImage, id: id)
            
            imageUploadObservable
                .subscribe { event in
                    switch event {
                    case .success(let url):
                        if let url {
                            updatedData[Menu.CodingKeys.menuPath.rawValue] = id
                            updatedData[Menu.CodingKeys.menuImage.rawValue] = url
                        }
                        firestoreReferences.updateData(updatedData)
                        completable(.completed)
                    case .failure(let error):
                        completable(.error(error))
                    }
                }
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }

    
    func deleteMenu(menuID: String, menuImagePath: String) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self else { return Disposables.create() }
            
            let firestoreReferences = FirestoreReferences.getMenuDocumentReferences(menuID: menuID)
            
            firestoreReferences.delete()
            self.deleteMenuImageFromStorage(path: menuImagePath)
            completable(.completed)
            return Disposables.create()
        }
    }
}

private extension MenuRepositoryImpl {
    func addMenuToFirestore(restoID: String, menuName: String, menuDescription: String, menuPrice: Int, menuStock: Int, imageUrl: String, menuPath: String) throws {
        let (newDocument, id) = self.firestoreServices.generateDocumentID(type: .menu)
        let menu = Menu(id: id, restoID: restoID, menuName: menuName, menuDescription: menuDescription, menuPrice: menuPrice, menuImage: imageUrl, menuPath: menuPath, dateCreated: Date(), stock: menuStock)
        try newDocument.setData(from: menu, merge: false)
    }
    
    func uploadImage(id: String, menuImage: UIImage, type: ReferenceStorageType) -> RxSwift.Single<String> {
        firebaseStorageServices.uploadImage(path: id, menuImage: menuImage, type: type)
    }
    
    func deleteMenuImageFromStorage(path: String) {
        Task {
            let firebaseStorageReferences = FirebaseStorageReferences.setReferenceStorage(path: path, type: .menu)
            try await firebaseStorageReferences.delete()
        }
    }
    
    func generalUpdatedData(_ updatedData: inout [String: Any], menuName: String?, menuDescription: String?, menuPrice: Int?, menuStock: Int?) {
        if let menuName {
            updatedData[Menu.CodingKeys.menuName.rawValue] = menuName
        }
        if let menuDescription {
            updatedData[Menu.CodingKeys.menuDescription.rawValue] = menuDescription
        }
        if let menuPrice {
            updatedData[Menu.CodingKeys.menuPrice.rawValue] = menuPrice
        }
        if let menuStock {
            updatedData[Menu.CodingKeys.stock.rawValue] = menuStock
        }
    }
    
    func getImageUploadObservable(menuImage: UIImage?, id: String) -> Single<String?> {
        if let menuImage {
            return self.uploadImage(id: id, menuImage: menuImage, type: .menu).map { Optional($0) }
        } else {
            return Single.just(nil)
        }
    }
}
