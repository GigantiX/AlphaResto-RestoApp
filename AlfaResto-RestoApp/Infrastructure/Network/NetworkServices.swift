//
//  NetworkServices.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 26/06/24.
//

import Foundation
import RxSwift
import Alamofire
import GoogleMaps

protocol NetworkService {
    func requestNotif(endpoint: Requestable) -> Completable
    func requestDirectionMaps(endpoint: Requestable) -> Observable<DirectionsResponse>
}

final class DefaultNetworkService {

    private let config: NetworkConfigurable
    
    init(config: NetworkConfigurable) {
        self.config = config
    }
}

extension DefaultNetworkService: NetworkService {
    
    func requestNotif(endpoint: Requestable) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self else { return Disposables.create() }
            do {
                let urlRequest = try endpoint.urlRequest(with: self.config)
                
                AF.request(urlRequest).response { response in
                    if let error = response.error {
                        completable(.error(error))
                        return
                    }
                    completable(.completed)
                }
            } catch {
                completable(.error(AppError.unexpectedError))
            }
            return Disposables.create()
        }
    }
    
    func requestDirectionMaps(endpoint: Requestable) -> RxSwift.Observable<DirectionsResponse> {
        return Observable.create { [weak self] observer in
            guard let self else { return Disposables.create() }
            
            do {
                let urlRequest = try endpoint.urlRequest(with: self.config)
                AF.request(urlRequest).responseDecodable(of: DirectionsResponse.self) { response in
                    switch response.result {
                    case .success(let direction):
                        observer.onNext(direction)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(AppError.errorFetchData)
                    }
                }
            } catch {
                observer.onError(AppError.unexpectedError)
            }
            return Disposables.create()
        }
    }
}
