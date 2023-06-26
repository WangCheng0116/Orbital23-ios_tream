//
//  AuthenticationUITests.swift
//  itineraryUITests
//
//  Created by yuchenbo on 25/6/23.
//

import XCTest

class AuthenticationUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        app = nil
    }
    
    func testLoginAndLogout() {
        // UI test for login and logout functionality
        
        // Tap on the "Sign In with Email" button
        app.buttons["Sign In with Email"].tap()
        
        // Fill in the email and password fields
        let emailTextField = app.textFields["Email..."]
        XCTAssertTrue(emailTextField.exists)
        emailTextField.tap()
        emailTextField.typeText("example1@email.com")
        
        let passwordSecureField = app.secureTextFields["Password..."]
        XCTAssertTrue(passwordSecureField.exists)
        passwordSecureField.tap()
        passwordSecureField.typeText("password123")
        
        // Tap on the "Sign In" button
        let loginButton = app.buttons["Sign In"]
        XCTAssertTrue(loginButton.exists)
        loginButton.tap()

       
    }
}
