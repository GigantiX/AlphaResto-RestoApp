
//
//  AlfaResto_RestoAppUITests.swift
//  AlfaResto-RestoAppUITests
//
//  Created by Abraham David Rumondor on 21/11/24.
//

import XCTest

final class AlfaResto_RestoAppUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        let app = XCUIApplication()
            app.launch()

            // Attempt to log out if already logged in
            try? attemptLogout(app: app)
    }
    
    func attemptLogout(app: XCUIApplication) throws {
        let tabBar = app.tabBars["Tab Bar"]

        // Check if the Profile tab exists
        if tabBar.buttons["Profile"].exists {
            tabBar.buttons["Profile"].tap()

            let moreButton = app.buttons["More"]
            if moreButton.waitForExistence(timeout: 3) {
                moreButton.tap()

                let collectionViewsQuery = app.collectionViews
                let logoutButton = collectionViewsQuery.buttons["Logout"]

                if logoutButton.waitForExistence(timeout: 3) {
                    logoutButton.tap()

                    let logoutAlert = app.alerts["Logout"]
                    if logoutAlert.waitForExistence(timeout: 3) {
                        logoutAlert.buttons["Okay"].tap()
                    }
                }
            }
        }
    }

    override func tearDownWithError() throws {
    }

    func login(app: XCUIApplication) {
            let emailTextField = app.textFields["example@email.com"]
            XCTAssertTrue(emailTextField.exists, "Email text field should exist")
            emailTextField.tap()
            emailTextField.typeText("admin@alfaresto.com")
        
        let doneButton = app.toolbars["Toolbar"].buttons["Done"]
        doneButton.tap()
            
            let passwordSecureField = app.secureTextFields["**********"]
            XCTAssertTrue(passwordSecureField.exists, "Password secure text field should exist")
            passwordSecureField.tap()
            passwordSecureField.typeText("admin123")
        
        doneButton.tap()
        
        let loginButton = app.buttons["Login"]
            XCTAssertTrue(loginButton.exists, "Login button should exist")
            loginButton.tap()
    }

    @MainActor
    func testLogin() throws {
        let app = XCUIApplication()
        app.launch()
        
        try? attemptLogout(app: app)
            
        login(app: app)
    }
    
    @MainActor
    func testEditItem() throws {
        let app = XCUIApplication()
        app.launch()
        
        login(app: app)
        
        let tabBar = app.tabBars["Tab Bar"]
            let existsPredicate = NSPredicate(format: "exists == true")
            expectation(for: existsPredicate, evaluatedWith: tabBar, handler: nil)

            waitForExpectations(timeout: 5, handler: nil)
        
        editItemWithDynamicConditions(app: app)
    }
    
    func editItemWithDynamicConditions(app: XCUIApplication) {

        let tabBar = app.tabBars["Tab Bar"]
        XCTAssertTrue(tabBar.buttons["Menu"].exists, "Menu tab should exist")
        tabBar.buttons["Menu"].tap()

        let collectionViewsQuery = app.collectionViews
        let ayamGacorCell = collectionViewsQuery.cells.otherElements.containing(.staticText, identifier: "Ayam Gacor").element
        let bebekZeusCell = collectionViewsQuery.cells.otherElements.containing(.staticText, identifier: "Bebek Zeus").element

        var currentMenuName: String
        if ayamGacorCell.exists {
            currentMenuName = "Ayam Gacor"
            ayamGacorCell.buttons["compose"].tap()
        } else if bebekZeusCell.exists {
            currentMenuName = "Bebek Zeus"
            bebekZeusCell.buttons["compose"].tap()
        } else {
            XCTFail("Neither Ayam Gacor nor Bebek Zeus menu items found")
            return
        }

        var newMenuName: String
        var newPrice: String
        var newStock: String

        if currentMenuName == "Ayam Gacor" {
            newMenuName = "Bebek Zeus"
            newPrice = "5000"
            newStock = "10"
        } else {
            newMenuName = "Ayam Gacor"
            newPrice = "10000"
            newStock = "5"
        }

        let itemNameField = app.textFields["Ex. Ayam Geprek"]
        XCTAssertTrue(itemNameField.exists, "Item name text field should exist")
        itemNameField.tap()
        itemNameField.clearAndEnterText(newMenuName)
        
        let doneButton = app.toolbars["Toolbar"].buttons["Done"]
        doneButton.tap()

        let priceField = app.textFields.element(boundBy: 1) // Assuming price field is the first text field
        XCTAssertTrue(priceField.exists, "Price text field should exist")
        priceField.tap()
        priceField.clearAndEnterText(newPrice)
        
        doneButton.tap()

        let stockField = app.textFields.element(boundBy: 2) // Assuming stock field is the second text field
        XCTAssertTrue(stockField.exists, "Stock text field should exist")
        stockField.tap()
        stockField.clearAndEnterText(newStock)
        
        doneButton.tap()

        // Save the updates
        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.exists, "Save button should exist")
        saveButton.tap()

        // Confirm the success alert
        let editedAlert = app.alerts["Edited"]
        XCTAssertTrue(editedAlert.exists, "Edited alert should appear")
        editedAlert.buttons["Okay"].tap()

        let profileButton = tabBar.buttons["Profile"]
            XCTAssertTrue(profileButton.waitForExistence(timeout: 5), "Profile button should appear after edit")
            profileButton.tap()
        
        let moreButton = app.buttons["More"]
        XCTAssertTrue(moreButton.exists, "More button should exist")
        moreButton.tap()

        let logoutButton = collectionViewsQuery.buttons["Logout"]
        XCTAssertTrue(logoutButton.exists, "Logout button should exist")
        logoutButton.tap()

        let logoutAlert = app.alerts["Logout"]
        XCTAssertTrue(logoutAlert.exists, "Logout alert should appear")
        logoutAlert.buttons["Okay"].tap()
    }
}

extension XCUIElement {
    func clearAndEnterText(_ text: String) {
        guard self.exists else { return }
        
        self.tap()
        
        // Select all existing text by simulating a swipe to select and deleting it
        self.tap() // Focus on the text field
        let currentText = self.value as? String ?? ""
        
        // If there's text, clear it
        if !currentText.isEmpty {
            let deleteString = String(repeating: "\u{8}", count: currentText.count) // Use backspace to delete all text
            self.typeText(deleteString)
        }
        
        // Type in the new text
        self.typeText(text)
    }
}
