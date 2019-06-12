
//
//  TestRatingModel.swift
//  FoodTrackerTests
//
//  Created by Matthew Hjelm on 6/5/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import XCTest
@testable import FoodTracker

class TestRatingModel: XCTestCase {
    let count = 3
    let type = "Star"
    var rating: RatingModel!
    
    override func setUp() {
        rating = RatingModel(withMaxRatingOf: count, andDescription: type)
    }
    
    func testConstructor() {
        XCTAssertNil(RatingModel(withMaxRatingOf: 0, andDescription: type), "RatingModel should not initailze when given a max rating of 0")
        XCTAssertNil(RatingModel(withMaxRatingOf: -1, andDescription: type), "RatingModel should not initalize when given a negative max rating")
        XCTAssertNotNil(RatingModel(withMaxRatingOf: 1, andDescription: type), "RatingModel should initalize when giving a max rating greater than 0")
    }

    func testDefaultRating() {
        let expected = 0
        let actual = rating.currentRating()
        XCTAssertEqual(actual, expected, "Default rating should be \(expected), actually was \(actual)")
    }
    
    func testUpdateRating() {
        let expected = [true, true, false]
        let value = 2
        let actual = rating.updateRating(to: value)!
        XCTAssertEqual(expected, actual, "UpdateRating should return \(expected), actually was \(actual)")
        
        _ = rating.updateRating(to: value)
        let currentRating = rating.currentRating()
        let expectedRating = 0
        XCTAssertEqual(expectedRating, currentRating, "updateRating should set the current rating to \(expectedRating) when the current rating is used, actually was \(currentRating) ")
        
        XCTAssertNil(rating.updateRating(to: -1), "updateRating should return 'nil' when using '-1'")
        XCTAssertNil(rating.updateRating(to: count+1), "updateRating should return 'nil' when using a value larger than the max rating")
    }
    
    func testCurrentRating() {
        _ = rating.updateRating(to: count)
        let actual = rating.currentRating()
        XCTAssertEqual(actual, count, "CurrentRating should return \(count) when updateRating takes \(count). Actually was, \(actual)")
    }
    
    func testHintString() {
        let newRating = 2
        _ = rating.updateRating(to: newRating)
        let expectedHint = "Tap to reset the rating to zero."
        for index in 0..<count {
            if index+1 == newRating {
                XCTAssertEqual(rating.hintString(forIndex: index), expectedHint, "Hint should be '\(expectedHint)' when rating is the same as the nth item (which is index+1)")
            }
            else {
                XCTAssertNil(rating.hintString(forIndex: index), "Hint should be 'nil' when nth item is not the same as the rating, failed at index \(index)")
            }
        }
    }
    
    func testValueString() {
        let expectedStrings = [0: "No rating set.",
                               1: "1 \(type) set.",
                               2: "2 \(type)s set."]
        for value in [0, 1, 2] {
            _ = rating.updateRating(to: value)
            let currentString = expectedStrings[value]!
            XCTAssertEqual(rating.valueString(), currentString, "valueString should return \(currentString) when rating is updated to \(value)")
        }
    }

}
