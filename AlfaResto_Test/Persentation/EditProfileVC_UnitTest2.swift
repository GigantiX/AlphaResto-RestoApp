//
//  EditProfileVC_UnitTest2.swift
//  AlfaResto_Test
//
//  Created by Axel Ganendra on 18/11/24.
//

import XCTest
@testable import AlfaResto_RestoApp

//Unit Testing using direct Storyboard
final class EditProfileVC_UnitTest2: XCTestCase {
    
    var vc: EditProfileViewController!
    
    override func setUp() {
        super.setUp()
        //Call the storyboard
        let storyboard = UIStoryboard(name: "EditProfileViewController", bundle: nil)
        vc = storyboard.instantiateViewController(identifier: "EditProfileViewController") as? EditProfileViewController
        vc.loadViewIfNeeded()
        
        //set dummy data
        vc.data = ProfileStoreModel(
            closingTime: "10:00 PM",
            is24hours: true,
            openingTime: "8:00 AM",
            address: "Old Address",
            description: "Old Description",
            email: "test@example.com",
            id: "1",
            token: "testToken",
            image: "testImage",
            isTemporaryClose: false,
            phoneNumber: "1234567890",
            latitude: 10.0,
            longitude: 20.0,
            totalRevenue: 100
        )
    }
    
    func test_isSavable_ShouldReturnTrue_WhenDataIsModified() {
        // Simulate user input via UI components
        vc.textFieldPhoneNumber.text = "0987654321" // New phone number
        vc.textViewAddress.text = "New Address"    // New address
        vc.textViewDescription.text = "New Description"
        vc.switch24Hours.isOn = false
        vc.textFieldOpenHour.text = "9:00 AM"
        vc.textFieldCloseHour.text = "9:00 PM"
        
        // When
        let result = vc.isSavable()
        
        // Then
        XCTAssertTrue(result, "Expected isSavable to return true when data is modified.")
    }
    
    func test_isSavable_ShouldReturnFalse_WhenDataIsUnchanged() {
        // Simulate unchanged UI component states
        vc.textFieldPhoneNumber.text = "1234567890"
        vc.textViewAddress.text = "Old Address"
        vc.textViewDescription.text = "Old Description"
        vc.switch24Hours.isOn = true
        vc.textFieldOpenHour.text = "8:00 AM"
        vc.textFieldCloseHour.text = "10:00 PM"
        
        // When
        let result = vc.isSavable()
        
        // Then
        XCTAssertFalse(result, "Expected isSavable to return false when data is unchanged.")
    }
    
}
