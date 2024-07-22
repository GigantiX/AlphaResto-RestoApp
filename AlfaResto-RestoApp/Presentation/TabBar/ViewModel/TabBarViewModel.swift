//
//  TabBarViewModelImpl.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 28/06/24.
//

import Foundation
import RxSwift

enum TabBarResult {
    case success
    case failure(Error)
}

protocol TabBarViewModelInput {
    func getOnGoingOrderCount()
}

protocol TabBarViewModelOutput {
    var onGoingOrderCount: Int? { get set }
    var updateTokenObservable: PublishSubject<TabBarResult> { get }
    var getOnGoingOrderCountObservable: PublishSubject<TabBarResult> { get }
    var disposeBag: DisposeBag { get }
}

protocol TabBarViewModel: TabBarViewModelInput, TabBarViewModelOutput { }

final class TabBarViewModelImpl: TabBarViewModel {
    
    // MARK: - Use Case
    private let orderUseCase: OrderUseCase
    
    // MARK: - Output
    var onGoingOrderCount: Int?
    var updateTokenObservable = PublishSubject<TabBarResult>()
    var getOnGoingOrderCountObservable = PublishSubject<TabBarResult>()
    var disposeBag = DisposeBag()
    
    init(orderUseCase: OrderUseCase) {
        self.orderUseCase = orderUseCase
    }
    
}

extension TabBarViewModelImpl {
    func getOnGoingOrderCount() {
        orderUseCase.executeGetOnGoingOrderCount()
            .subscribe { [weak self] event in
                guard let self else { return }
                switch event {
                case .next(let count):
                    self.onGoingOrderCount = count
                    self.getOnGoingOrderCountObservable.onNext(.success)
                case .error(let error):
                    self.getOnGoingOrderCountObservable.onNext(.failure(error))
                default:
                    break
                }
            }
            .disposed(by: self.disposeBag)
    }
}

