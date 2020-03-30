//
//  scoreTitleLabel.swift
//  Stack Practice
//
//  Created by Patrick Lawler on 2/13/20.
//  Copyright © 2020 Patrick Lawler. All rights reserved.
//

import UIKit

class ScoreboardTitleLabel: UILabel {
    
    init() {
        super.init(frame: .zero)
        textColor           = .white
        font                = UIFont.preferredFont(forTextStyle: .callout)
        textAlignment       = .center
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
