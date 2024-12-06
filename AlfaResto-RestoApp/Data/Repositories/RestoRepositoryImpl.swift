//
//  RestoRepository.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 14/06/24.
//

import Foundation
import RxSwift
import FirebaseStorage

final class RestoRepositoryImpl {
    private let storageRef = Storage.storage().reference()
    private let disposeBag = DisposeBag()
    private let authenticationServices: AuthenticationServices
    private let firestoreServices: FirestoreServices
    private let firebaseStorageServices: FirebaseStorageServices
    
    init(authenticationServices: AuthenticationServices,
         firestoreServices: FirestoreServices,
         firebaseStorageServices: FirebaseStorageServices
    ) {
        self.authenticationServices = authenticationServices
        self.firestoreServices = firestoreServices
        self.firebaseStorageServices = firebaseStorageServices
    }
}

extension RestoRepositoryImpl: RestoRepository {
    
    func updateProfile(close: String, is24h: Bool, open: String, address: String, desc: String, image: UIImage, telp: String) -> RxSwift.Completable {
        return Completable.create { completable in
            let firestoreReff = FirestoreReferences.getRestoDocumentReferences(restoID: UserDefaultManager.restoID ?? "")
            self.uploadImage(image: image, name: UserDefaultManager.restoID ?? "").subscribe(onSuccess: { link in
                let data = [
                    "closing_time": close,
                    "is_open_24_hour": is24h,
                    "opening_time": open,
                    "resto_address": address,
                    "resto_description": desc,
                    "resto_image": link,
                    "resto_no_telp": telp,
                ]
                
                firestoreReff.updateData(data) { error in
                    if let error {
                        completable(.error(error))
                    } else {
                        completable(.completed)
                    }
                }
                
            }, onFailure: { error in
                let data = [
                    "closing_time": close,
                    "is_open_24_hour": is24h,
                    "opening_time": open,
                    "resto_address": address,
                    "resto_description": desc,
                    "resto_no_telp": telp
                ]
                
                firestoreReff.updateData(data) { error in
                    if let error {
                        completable(.error(error))
                    } else {
                        completable(.completed)
                    }
                }
            }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func fetchCustomerCount() -> Observable<Int?> {
        return Observable.create { observer in
            
            _ = FirestoreReferences.getUserCollectionReferences()
                .addSnapshotListener { querySnapshot, error in
                    if let error {
                        observer.onError(AppError.errorFetchData)
                        return
                    }
                    
                    if let querySnapshot {
                        observer.onNext(querySnapshot.count)
                    }
                }
            
            return Disposables.create()
        }
    }
    
    func fetchProfile(restoID: String) -> RxSwift.Observable<ProfileStoreModel> {
        return Observable.create { observer in
            Task {
                do {
                    let restoDocument = try await FirestoreReferences.getRestoDocumentReferences(restoID: restoID).getDocument(as: ProfileStoreModel.self)
                    observer.onNext(restoDocument)
                } catch {
                    observer.onError(AppError.errorFetchData)
                }
            }
            return Disposables.create()
        }
    }
    
    func updateToken(restoID: String, token: String) -> Completable {
        return Completable.create { completable in
            let firestoreRestoReferences = FirestoreReferences.getRestoDocumentReferences(restoID: restoID)
            
            let updatedData: [String: Any] = [
                ProfileStoreModel.CodingKeys.token.rawValue: token
            ]
            
            firestoreRestoReferences.updateData(updatedData)
            completable(.completed)
            return Disposables.create()
        }
    }
    
    func updateTemporaryClose(restoID: String, isClose: Bool) -> Completable {
        return Completable.create { completable in
            let firestoreRestoReferences = FirestoreReferences.getRestoDocumentReferences(restoID: restoID)
            
            let updatedData: [String: Any] = [
                ProfileStoreModel.CodingKeys.isTemporaryClose.rawValue: isClose
            ]
            
            firestoreRestoReferences.updateData(updatedData)
            completable(.completed)
            return Disposables.create()
        }
    }
    
    func login(email: String, password: String) -> RxSwift.Observable<String> {
        authenticationServices.login(email: email, password: password)
    }
    
    func logout() -> RxSwift.Completable {
        authenticationServices.logout()
    }
}


private extension RestoRepositoryImpl {
    func uploadImage(image: UIImage, name: String) -> RxSwift.Single<String> {
        return Single.create { single in
            guard let imageData = image.jpegData(compressionQuality: 0.5) else {
                single(.failure(NSError(domain: "Error Covert Image", code: -1)))
                return Disposables.create()
            }
            let path = self.storageRef.child("resto_profile/\(name).jpg")
            
            let uploadTask = path.putData(imageData, metadata: nil) { metadata, error in
                if let error {
                    single(.failure(error))
                } else {
                    path.downloadURL { url, error in
                        if let error {
                            single(.failure(error))
                        } else if let url {
                            single(.success("\(url)"))
                        }
                    }
                }
                
            }
            return Disposables.create {
                uploadTask.cancel()
            }
        }
    }
}
