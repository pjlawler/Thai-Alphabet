//
//  ScoreLabel.swift
//  Stack Practice
//
//  Created by Patrick Lawler on 2/6/20.
//  Copyright © 2020 Patrick Lawler. All rights reserved.
//

import UIKit


class ScoreLabel: UILabel {

     init(type: ScoreBoardType) {
        super.init(frame: .zero)
        
        backgroundColor     = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        textColor           = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        font                = UIFont.preferredFont(forTextStyle: .title2)
        textAlignment       = .center
        layer.borderColor   = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.borderWidth   = 2.0
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 75),
            self.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
