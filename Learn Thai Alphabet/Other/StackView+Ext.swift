//
//  StackView+Ext.swift
//  Stack Practice
//
//  Created by Patrick Lawler on 2/16/20.
//  Copyright © 2020 Patrick Lawler. All rights reserved.
//

import UIKit

extension UIStackView {
    
    func addArrangedSubviews(views: UIView...) {
        for view in views { self.addArrangedSubview(view)}
    }
    
}
