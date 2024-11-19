//
//  EditProfileVC_UnitTest.swift
//  AlfaResto_Test
//
//  Created by Axel Ganendra on 18/11/24.
//

import XCTest
@testable import AlfaResto_RestoApp

final class EditProfileVC_UnitTest: XCTestCase {
    
    var vc: EditProfileViewController!
    var dummyData: ProfileStoreModel!
    var updatedData: ProfileStoreModel!
    
    private var textFieldPhoneNumber: UITextField!
    private var textViewAddress: UITextView!
    private var textViewDescription: UITextView!
    private var textFieldOpenHour: UITextField!
    private var textFieldCloseHour: UITextField!
    private var switch24Hours: UISwitch!
    
    override func setUp() {
        super.setUp()
        vc = EditProfileViewController()
        vc.loadView()
        
        dummyData = ProfileStoreModel(
            closingTime: "18:00", is24hours: false, openingTime: "09:00",
            address: "Old Address", description: "Old Description",
            email: "test@example.com", id: "123", token: "token123",
            image: "image.png", isTemporaryClose: false, phoneNumber: "123456789",
            latitude: 0.0, longitude: 0.0, totalRevenue: 1000
        )
        
        updatedData = ProfileStoreModel(
            closingTime: "22:00", is24hours: false, openingTime: "10:00",
            address: "New Address", description: "New Description",
            email: "test@example.com", id: "123", token: "token123",
            image: "newImage.png", isTemporaryClose: false, phoneNumber: "987654321",
            latitude: 0.0, longitude: 0.0, totalRevenue: 2000
        )
        
        vc.data = dummyData
        
        // Initialize UI elements with strong references
        textFieldPhoneNumber = UITextField()
        textViewAddress = UITextView()
        textViewDescription = UITextView()
        textFieldOpenHour = UITextField()
        textFieldCloseHour = UITextField()
        switch24Hours = UISwitch()
        
        // Assign the strong references to the view controller's weak properties
        vc.textFieldPhoneNumber = textFieldPhoneNumber
        vc.textViewAddress = textViewAddress
        vc.textViewDescription = textViewDescription
        vc.textFieldOpenHour = textFieldOpenHour
        vc.textFieldCloseHour = textFieldCloseHour
        vc.switch24Hours = switch24Hours
    }
    
    func test_isSavable_shouldReturnTrueWhenDataIsModified() {
        // Simulate modified data
        vc.textFieldPhoneNumber.text = updatedData.phoneNumber
        vc.textViewAddress.text = updatedData.address
        vc.textViewDescription.text = updatedData.description
        vc.textFieldOpenHour.text = updatedData.openingTime
        vc.textFieldCloseHour.text = updatedData.closingTime
        vc.switch24Hours.isOn = updatedData.is24hours
        
        // Call the method
        let result = vc.isSavable()
        
        // Assert
        XCTAssertTrue(result, "isSavable should return true when data is modified")
    }
    
    func test_isSavable_shouldReturnFalseWhenDataIsUnchanged() {
        // Simulate unchanged data
        vc.textFieldPhoneNumber.text = dummyData.phoneNumber
        vc.textViewAddress.text = dummyData.address
        vc.textViewDescription.text = dummyData.description
        vc.textFieldOpenHour.text = dummyData.openingTime
        vc.textFieldCloseHour.text = dummyData.closingTime
        vc.switch24Hours.isOn = dummyData.is24hours
        
        // Call the method
        let result = vc.isSavable()
        
        // Assert
        XCTAssertFalse(result, "isSavable should return false when data is unchanged")
    }
    
    func test_validateOpenHours_shouldReturnTrueWhenHoursAreModified() {
        // Simulate modified opening and closing hours
        vc.textFieldOpenHour.text = "10:00"
        vc.textFieldCloseHour.text = "22:00"
        
        // Call the method
        let result = vc.validateOpenHours()
        
        // Assert
        XCTAssertFalse(result, "validateOpenHours should return true when hours are modified")
    }
    
    func test_validateOpenHours_shouldReturnFalseWhenHoursAreUnchanged() {
        // Simulate unchanged opening and closing hours
        vc.textFieldOpenHour.text = dummyData.openingTime
        vc.textFieldCloseHour.text = dummyData.closingTime
        
        // Call the method
        let result = vc.validateOpenHours()
        
        // Assert
        XCTAssertFalse(result, "validateOpenHours should return false when hours are unchanged")
    }
    
    func test_validateOpenHours_shouldReturnFalseWhenDataIsNil() {
        // Set data to nil
        vc.data = nil
        
        // Call the method
        let result = vc.validateOpenHours()
        
        // Assert
        XCTAssertFalse(result, "validateOpenHours should return false when data is nil")
    }
    
}
