//
//  FirebaseStorageServices.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 19/06/24.
//

import Foundation
import FirebaseStorage
import RxSwift

protocol FirebaseStorageServices {
    func uploadImage(path: String, menuImage: UIImage, type: ReferenceStorageType) -> Single<String>
}

final class FirebaseStorageServicesImpl {
    init() { }
}

extension FirebaseStorageServicesImpl: FirebaseStorageServices {
    func uploadImage(path: String, menuImage: UIImage, type: ReferenceStorageType) -> Single<String> {
        return Single.create { single in
            
            let firebaseStorageReferences = FirebaseStorageReferences.setReferenceStorage(path: path, type: type)
            
            let imageData = menuImage.jpegData(compressionQuality: 0.5) ?? Constant.alfaRestoLogoImage?.jpegData(compressionQuality: 0.5) ?? Data()
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
        
            // Upload to firebase storage
            let uploadTask = firebaseStorageReferences.putData(imageData, metadata: metadata) { metadata, error in
                
                if let error {
                    single(.failure(error))
                    return
                }
                
                // Get download url
                firebaseStorageReferences.downloadURL { url, error in
                    if let error {
                        single(.failure(error))
                        debugPrint("Error Download: \(error.localizedDescription)")
                        return
                    }
                    
                    if let url {
                        single(.success(url.absoluteString))
                    }
                }
            }
            
            return Disposables.create {
                uploadTask.cancel()
            }
        }
    }
}
