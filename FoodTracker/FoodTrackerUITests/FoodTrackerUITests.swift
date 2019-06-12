//
//  FoodTrackerUITests.swift
//  FoodTrackerUITests
//
//  Created by Matthew Hjelm on 6/3/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import XCTest
@testable import FoodTracker

class FoodTrackerUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        
    }
    
    func getStarButtonsForFirstCell() -> [XCUIElement] {
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Caprese Salad"]/*[[".cells.staticTexts[\"Caprese Salad\"]",".staticTexts[\"Caprese Salad\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        expectation(for: NSPredicate(format: "exists == true"), evaluatedWith:  app.textFields["Enter meal name"], handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        return app.buttons.containing(NSPredicate(format: "identifier endswith '_star'")).allElementsBoundByIndex
    }

    func testTableViewDefaultNumberOfCells() {
        let expected = 3
        XCTAssertEqual(XCUIApplication().tables.cells.count, expected, "The tableview should show \(expected) cells when first loaded")
    }
    
    func testNumberOfStars() {
        let rating_buttons = getStarButtonsForFirstCell()
        let expected = 5
        XCTAssertEqual(rating_buttons.count, expected, "\(rating_buttons) should have \(expected) elements")
    }

    func testRatingCanChange() {
        let rating_buttons = getStarButtonsForFirstCell()
        app.buttons["3_star"].tap()
        for (index, button) in rating_buttons.enumerated() {
            if index < 3 {
                XCTAssertEqual(button.isSelected, true, "Button \(button) should be selected when a meal has a rating of 3 stars")
            }
            else {
                XCTAssertEqual(button.isSelected, false, "Button \(button) should not be selected when a meal has a rating of 3 stars")
            }
        }
    }
}
