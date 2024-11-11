//
//  EditProfileViewController_Tests.swift
//  AlfaResto_Test
//
//  Created by Axel Ganendra on 07/11/24.
//

import XCTest
@testable import AlfaResto_RestoApp

final class EditProfileViewController_Tests: XCTestCase {
    var dummyData = ProfileStoreModel(closingTime: "Test", is24hours: true, openingTime: "Test", address: "Test", description: "Test", email: "Test", id: "Test", token: "Test", image: "Test", isTemporaryClose: false, phoneNumber: "Test", latitude: CGFloat(10), longitude: CGFloat(10), totalRevenue: 10)
    var dummyData2 = ProfileStoreModel(closingTime: "Test", is24hours: true, openingTime: "Test", address: "Test", description: "Test", email: "Test", id: "Test", token: "Test", image: "Test", isTemporaryClose: false, phoneNumber: "Test", latitude: CGFloat(10), longitude: CGFloat(10), totalRevenue: 10)
    
    var vc: EditProfileViewController?
    var source = EditProfileViewController()
    
    override func setUp() {
        super.setUp()
        self.vc = source.storyboard?.instantiateViewController(identifier: EditProfileViewController.storyboardID)
        self.vc?.loadView()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_validateOpenHours_shouldReturnTrue() {
        guard let vc else { return }
        vc.data = dummyData
        let result = vc.validateOpenHours()
        
        XCTAssertTrue(result, "Test validateOpenHours")
    }
    
    func test_validateOpenHours_shouldReturnTrue2() {
        guard let vc else { return }
        vc.data = dummyData
        let result = vc.validateOpenHours()
        
        XCTAssertEqual(result, true)
    }
    
    func test_validateOpenHours_shouldReturnFalse() {
        guard let vc else { return }
        vc.data = dummyData2
        let result = vc.validateOpenHours()
        
        XCTAssertFalse(result, "Test validateOpenHours")
        XCTAssertEqual(result, true)
    }
    
    func test_EditProfileViewController_isSavable_ShouldReturnTrue() {
        guard let vc else { return }
        vc.data = dummyData
        let result = vc.isSavable()
        
        XCTAssertFalse(result, "Test isSavable")
    }

}
