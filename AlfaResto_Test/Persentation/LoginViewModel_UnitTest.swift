//
//  LoginViewModel_UnitTest.swift
//  AlfaResto_Test
//
//  Created by Axel Ganendra on 03/12/24.
//

import XCTest
import RxSwift
@testable import AlfaResto_RestoApp

final class LoginViewModel_UnitTest: XCTestCase {
    
    var viewModel: LoginViewModelImpl!
    var restoUseCaseMock: RestoUseCaseMock!
    var fcmTokenHandlerMock: FCMTokenHandlerMock!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        restoUseCaseMock = RestoUseCaseMock()
        fcmTokenHandlerMock = FCMTokenHandlerMock()
        viewModel = LoginViewModelImpl(restoUseCase: restoUseCaseMock, fcmTokenHandler: fcmTokenHandlerMock)
        disposeBag = DisposeBag()
    }
    
    func testOperationSum() {
        //Given
        var x = 2
        var y = 3
        
        //When
        var result = viewModel.operateSum(a: x, b: y)
        
        //Then
        XCTAssertEqual(result, 5, "Testing on operation SUM")
    }
    
    override func tearDown() {
        viewModel = nil
        restoUseCaseMock = nil
        fcmTokenHandlerMock = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func testLoginSuccess() {
        let expectation = self.expectation(description: "Login success")
        let expectedUID = "12345"
        
        restoUseCaseMock.loginResult = .just(expectedUID)
        
        viewModel.loginObservable
            .subscribe(onNext: { result in
                switch result {
                case .success(let uid):
                    XCTAssertEqual(uid, expectedUID)
                    expectation.fulfill()
                case .failure:
                    XCTFail("Expected success but got failure")
                }
            })
            .disposed(by: disposeBag)
        
        try? viewModel.login(email: "test@example.com", password: "password")
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testLoginFailure() {
        let expectation = self.expectation(description: "Login failure")
        let expectedError = NSError(domain: "", code: -1, userInfo: nil)
        
        restoUseCaseMock.loginResult = .error(expectedError)
        
        viewModel.loginObservable
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    XCTFail("Expected failure but got success")
                case .failure(let error):
                    XCTAssertEqual(error as NSError, expectedError)
                    expectation.fulfill()
                }
            })
            .disposed(by: disposeBag)
        
        try? viewModel.login(email: "test@example.com", password: "password")
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testLoginEmptyFields() {
        XCTAssertThrowsError(try viewModel.login(email: "", password: "password")) { error in
            XCTAssertEqual(error as? AppError, AppError.texiFieldIsEmpty)
        }
        
        XCTAssertThrowsError(try viewModel.login(email: "test@example.com", password: "")) { error in
            XCTAssertEqual(error as? AppError, AppError.texiFieldIsEmpty)
        }
    }
    
    func testUpdateFCMTokenSuccess() {
        let expectation = self.expectation(description: "Update FCM token success")
        
        fcmTokenHandlerMock.updateTokenResult = .empty()
        
        viewModel.updateTokenObservable
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    expectation.fulfill()
                case .failure:
                    XCTFail("Expected success but got failure")
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.updateFCMToken(token: "newToken")
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testUpdateFCMTokenFailure() {
        let expectation = self.expectation(description: "Update FCM token failure")
        let expectedError = NSError(domain: "", code: -1, userInfo: nil)
        
        fcmTokenHandlerMock.updateTokenResult = .error(expectedError)
        
        viewModel.updateTokenObservable
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    XCTFail("Expected failure but got success")
                case .failure(let error):
                    XCTAssertEqual(error as NSError, expectedError)
                    expectation.fulfill()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.updateFCMToken(token: "newToken")
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}

class RestoUseCaseMock: RestoUseCase {
    
    //dummy UseCase for testing, only few func used
    func executeLogout() -> RxSwift.Completable {
        return RxSwift.Completable.empty()
    }
    
    func executeFetchProfile(restoID: String) -> RxSwift.Observable<AlfaResto_RestoApp.ProfileStoreModel> {
        RxSwift.Observable<AlfaResto_RestoApp.ProfileStoreModel>.empty()
    }
    
    func executeUpdateProfile(close: String, is24h: Bool, open: String, address: String, desc: String, image: UIImage, telp: String) -> RxSwift.Completable {
        RxSwift.Completable.empty()
    }
    
    func executeUpdateToken(restoID: String, token: String) -> RxSwift.Completable {
        RxSwift.Completable.empty()
    }
    
    func executeUpdateTemporaryClose(restoID: String, isClose: Bool) -> RxSwift.Completable {
        return RxSwift.Completable.empty()
    }
    
    func executeFetchCustomerCount() -> RxSwift.Observable<Int?> {
        return RxSwift.Observable<Int?>.empty()
    }
    
    var loginResult: Observable<String>!
    
    func executeLogin(email: String, password: String) -> Observable<String> {
        return loginResult
    }
}

class FCMTokenHandlerMock: FCMTokenHandler {
    func invalidateToken() {
    }
    
    var updateTokenResult: Completable!
    
    func updateTokenFCMToFirestore(with token: String) -> Completable {
        return updateTokenResult
    }
}
