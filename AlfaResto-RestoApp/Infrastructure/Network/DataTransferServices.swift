//
//  DataTransferServices.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 26/06/24.
//

import Foundation
import RxSwift
import Alamofire

protocol DataTransferService {
    func requestNotif(
        with endpoint: any ResponseRequestable
    ) -> Completable
    func requestDirectionMaps(
        with endpoint: any ResponseRequestable
    ) -> Observable<DirectionsResponse>
}

final class DataTransferServicesImpl {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DataTransferServicesImpl: DataTransferService {
    func requestNotif(with endpoint: any ResponseRequestable) -> Completable {
        self.networkService.requestNotif(endpoint: endpoint)
    }
    
    func requestDirectionMaps(with endpoint: any ResponseRequestable) -> Observable<DirectionsResponse> {
        self.networkService.requestDirectionMaps(endpoint: endpoint)
    }
}
