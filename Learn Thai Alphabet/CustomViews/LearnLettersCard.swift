//
//  LearnLettersCard.swift
//  Learn Thai Alphabet
//
//  Created by Patrick Lawler on 2/19/20.
//  Copyright © 2020 Patrick Lawler. All rights reserved.
//

import UIKit

class LearnLettersCard: UIImageView {
    var front           = UIImage()
    var letterNumber    = 0

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints   = false
        isUserInteractionEnabled                    = true
        backgroundColor                             = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        image                                       = front
        layer.borderColor                           = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.borderWidth                           = 1.0
        layer.shadowColor                           = UIColor.black.cgColor
        layer.shadowOffset                          = CGSize(width: 5, height: 5)
        layer.shadowRadius                          = 5.0
        layer.shadowOpacity                         = 1.0
    }
    
    func displayBlankCard() {
        letterNumber        = 0
        backgroundColor     = #colorLiteral(red: 0.9319444299, green: 0.805888474, blue: 0.5628086925, alpha: 1)
        image               = nil
    }
    
    
    func setCard(card: Int) {
        front               = UIImage(named: "thaiLetter\(card)")!
        letterNumber        = card
        backgroundColor     = #colorLiteral(red: 0.9319444299, green: 0.805888474, blue: 0.5628086925, alpha: 1)
        image               = front
    }
}

