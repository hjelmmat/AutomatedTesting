//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 11/2/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//
//  Edited by Matthew Hjelm on 6/6/19.

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    //MARK: Properties
    
    private var ratingButtons = [UIButton]()
    private var rating: RatingModel!
    private let starCount = 5
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons(withRating: rating.currentRating())
        }
    }
    
    //MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons(withRating: 0)
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons(withRating: 0)
    }
    
    //MARK: Button Action
    
    @objc func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButtons.firstIndex(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        updateButtonSelectionStates(to: rating.updateRating(to: index + 1)!)
    }

    
    func setupButtons(withRating value: Int) {
        
        // Clear any existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        rating = RatingModel(withMaxRatingOf: starCount, andDescription: "Star")!
        
        // Load Button Images
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named:"emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named:"highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for index in 0..<starCount {
            // Create the button
            let button = UIButton()
            
            // Set the button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // Set the accessibility label
            button.accessibilityLabel = "Set \(index + 1) star rating"
            button.accessibilityIdentifier = "\(index + 1)_star"
            
            // Setup the button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add the button to the stack
            addArrangedSubview(button)
            
            // Add the new button to the rating button array
            ratingButtons.append(button)
        }
        
        updateButtonSelectionStates(to: rating.updateRating(to: value)!)
    }

    //MARK: Public Methods
    func currentRating() -> Int {
        return rating.currentRating()
    }
    
    //MARK: Private Methods

    private func updateButtonSelectionStates(to states: [Bool]) {
        let valueString = rating.valueString()
        for (index, value) in states.enumerated() {
            let button = ratingButtons[index]
            button.isSelected = value
            button.accessibilityHint = rating.hintString(forIndex: index)
            button.accessibilityValue = valueString
        }
    }
}
