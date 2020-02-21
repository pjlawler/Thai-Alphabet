//
//  GridStack.swift
//  Stack Practice
//
//  Created by Patrick Lawler on 2/15/20.
//  Copyright © 2020 Patrick Lawler. All rights reserved.
//

import UIKit

class CustomStack: UIStackView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(stackAxis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, padding: CGFloat) {
        super.init(frame: .zero)
        self.axis           = stackAxis
        self.alignment      = alignment
        self.distribution   = distribution
        self.spacing        = padding
        configure()
    }
    
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}
