//
//  FirebaseDatabaseServices.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 26/06/24.
//

import Foundation
import RxSwift

protocol FirebaseDatabaseServices { 
    func setValue<T: Codable>(modelValue: T, type: ReferenceRealTimeDatabaseType) -> Completable
    func observeValue<T: Codable>(type: ReferenceRealTimeDatabaseType) -> Single<T?>
    func deleteValue(type: ReferenceRealTimeDatabaseType) -> Completable
}

final class FirebaseDatabaseServicesImpl {
    init() { }
}

extension FirebaseDatabaseServicesImpl: FirebaseDatabaseServices {
        
    func setValue<T: Codable>(modelValue: T, type: ReferenceRealTimeDatabaseType) -> RxSwift.Completable {
        return Completable.create { completable in
            let referenceDatabase = FirebaseDatabaseReferences.setReferenceRealTimeDatabase(type: type)
                        
            do {
                let newValue = try modelValue.toDictionary()
                referenceDatabase.setValue(newValue)
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    func observeValue<T: Codable>(type: ReferenceRealTimeDatabaseType) -> RxSwift.Single<T?> {
        return Single.create { single in
            
            let referencesDatabase = FirebaseDatabaseReferences.setReferenceRealTimeDatabase(type: type)
            referencesDatabase.observe(.value) { snapshot in
                do {
                    let result = try snapshot.data(as: T.self)
                    single(.success(result))
                } catch {
                    single(.failure(AppError.errorFetchData))
                }
            }
            
            
            return Disposables.create()
        }
    }
    
    func deleteValue(type: ReferenceRealTimeDatabaseType) -> RxSwift.Completable {
        return Completable.create { completable in
            
            let referenceRealtimeDB = FirebaseDatabaseReferences.setReferenceRealTimeDatabase(type: type)
            referenceRealtimeDB.removeValue()
            
            return Disposables.create()
        }
        
    }
}

