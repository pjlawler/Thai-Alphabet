//
//  CardsRemainingLabel.swift
//  Learn Thai Alphabet
//
//  Created by Patrick Lawler on 2/20/20.
//  Copyright © 2020 Patrick Lawler. All rights reserved.
//

import UIKit

class CardsRemainingLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    func configure() {
        backgroundColor         = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        textColor               = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        font                    = UIFont.preferredFont(forTextStyle: .title2)
        
        layer.backgroundColor   = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        layer.borderWidth       = 2.0
        
        textAlignment           = .center
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 100),
            self.heightAnchor.constraint(equalToConstant: 40)
        ])

    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
