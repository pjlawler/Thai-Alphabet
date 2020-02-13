//
//  ScoreLabel.swift
//  Stack Practice
//
//  Created by Patrick Lawler on 2/6/20.
//  Copyright © 2020 Patrick Lawler. All rights reserved.
//

import UIKit


enum ScoreBoardType {
    case correct
    case wrong
    case timer
}


class ScoreLabel: UILabel {

     init(type: ScoreBoardType) {
        super.init(frame: .zero)
        
        let labelWidth: CGFloat!
        
        
        switch type {
        case .correct, .wrong:
            backgroundColor = type == .correct ? .systemBlue : .systemRed
            textColor       = .white
            labelWidth      = 75
            text            = "-"
        case .timer:
            backgroundColor = .white
            textColor       = .black
            labelWidth      = 100
            text            = "--:--"
        }
        
        font                = UIFont.preferredFont(forTextStyle: .headline)
        textAlignment       = .center
        layer.borderColor   = UIColor.black.cgColor
        layer.borderWidth   = 2.0
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: labelWidth),
            self.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
