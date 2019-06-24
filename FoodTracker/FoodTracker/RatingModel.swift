//
//  RatingModel.swift
//  FoodTracker
//
//  Created by Matthew Hjelm on 6/5/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import UIKit

class RatingModel: NSObject {
    
    // MARK: Properties
    private var rating = 0
    private let maxRating: Int
    private let type: String
    
    // MARK: Initialization
    init?(withMaxRatingOf max: Int, andDescription type: String) {
        // Ensure max rating is a positive number
        if max <= 0 {
            return nil
        }
        
        // Initalize stored properties
        maxRating = max
        self.type = type
    }
    
    // MARK: Public functions
    func updateRating(to value: Int) -> [Bool]? {
        if value < 0 || value > maxRating {
            return nil
        }
        if value == rating {
            rating = 0
        }
        else {
            rating = value
        }
        var state: [Bool] = []
        for index in 0..<maxRating {
            if index < rating {
                state.append(true)
            }
            else {
                state.append(false)
            }
        }
        return state
    }
    
    func hintString(forIndex index: Int) -> String? {
        let hintString: String?
        if rating  == index + 1 {
            hintString = "Tap to reset the rating to zero."
        } else {
            hintString = nil
        }
        return hintString
    }
    
    func valueString() -> String {
        let valueString: String
        switch (rating) {
        case 0:
            valueString = "No rating set"
        case 1:
            valueString = "1 \(type) set"
        default:
            valueString = "\(rating) \(type)s set"
        }
        return valueString
    }
    
    func currentRating() -> Int {
        return rating
    }
}
