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
    let salad = "Caprese Salad"
    let enterMeal = "Enter meal name"

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func clickFirstCell() {
        app.tables.cells.staticTexts["Caprese Salad"].tap()
        expectation(for: NSPredicate(format: "exists == true"), evaluatedWith:  app.textFields[enterMeal], handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func getStarButtonsForFirstCell() -> [XCUIElement] {
        clickFirstCell()
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

    func testMealNameSave() {
        let newName = "Caprese Salada"
        XCTAssertEqual(app.staticTexts.matching(identifier: newName).count, 0, "There should be no static text named \(newName)")
        clickFirstCell()
        app.textFields[enterMeal].tap()
        app.keyboards.keys["a"].tap()
        app.keyboards.buttons["Done"].tap()
        app.navigationBars[newName].buttons["Save"].tap()
        XCTAssertEqual(app.staticTexts.matching(identifier: newName).count, 1, "There should be one static text renamed to \(newName)")
    }
    
    func testMealRatingSave() {
        XCTAssertEqual(app.buttons.matching(NSPredicate(format: "value == '1 Star set'")).count, 0, "There should be 0 cells with 1 stars set")
        clickFirstCell()
        app.buttons["1_star"].tap()
        app.navigationBars[salad].buttons["Save"].tap()
        let expected = 5
        XCTAssertEqual(app.buttons.matching(NSPredicate(format: "value == '1 Star set'")).count, expected, "There should be \(expected) cells with 1 stars set when changing the rating to 1 and saving")
    }

    func testMealCancel() {
        print(app.staticTexts.allElementsBoundByIndex)
        XCTAssertEqual(app.staticTexts.matching(identifier: salad).count, 1, "There should be only one static text with the name \(salad) when the apps starts")
        clickFirstCell()
        app.textFields[enterMeal].tap()
        app.keyboards.keys["delete"].tap()
        app.buttons["Cancel"].tap()
        XCTAssertEqual(app.staticTexts.matching(identifier: salad).count, 1, "There should be only one static text with the name \(salad) when canceling a name overwrite")
    }
}
