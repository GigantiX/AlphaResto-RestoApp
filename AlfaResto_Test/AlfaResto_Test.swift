//
//  AlfaResto_Test.swift
//  AlfaResto_Test
//
//  Created by Axel Ganendra on 07/11/24.
//

import XCTest
@testable import AlfaResto_RestoApp

final class AlfaResto_Test: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_ProfileViewController_add_ShouldReturnValue() {
        let vc = ProfileViewController()
        let x = 10
        let y = 10
        
        let result = vc.add(a: x, b: y)
        
        XCTAssertEqual(result, 40)
    }
    
}
