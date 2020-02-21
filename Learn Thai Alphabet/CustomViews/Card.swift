//
//  Card.swift
//  Stack Practice
//
//  Created by Patrick Lawler on 2/5/20.
//  Copyright © 2020 Patrick Lawler. All rights reserved.
//

import UIKit


class Card: UIImageView {
    var front           = UIImage()
    var back            = UIImage()
    var letterNumber    = 0
    var isFlipped       = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
        backgroundColor     = .systemGray5
        image               = front
        isFlipped           = false
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 5, height: 5)
        layer.shadowRadius  = 5.0
        layer.shadowOpacity = 1.0
    }
    
    func flip() {
        
        switch isFlipped {
        case true: flipUp()
        case false: flipOver()
        }
    }
    
    func setFlashCard(card: Int) {
        front               = UIImage(named: "alphafront\(card)")!
        back                = UIImage(named: "alphaback\(card)")!
        letterNumber        = card
        backgroundColor     = .systemTeal
        image               = back
        isFlipped           = true
        alpha               = 1
    }
    
    
    private func flipOver() {
        isFlipped = true
        backgroundColor = #colorLiteral(red: 0.9319444299, green: 0.805888474, blue: 0.5628086925, alpha: 1)
        UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromLeft, animations: {
            self.image = self.back
        }) { (done) in }
    }
    
    
    private func flipUp() {
        isFlipped = false
        backgroundColor     = .systemBackground
        UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromLeft, animations: {
            self.image = self.front
        }) { (done) in }
        
    }
    
    
    func showAsCorrectCard() { backgroundColor     = #colorLiteral(red: 0.03346890584, green: 0.7481577992, blue: 0.0001659548288, alpha: 1) }
    func showAsWrongCard() { backgroundColor     = #colorLiteral(red: 0.9674087167, green: 0.2894938886, blue: 0, alpha: 1) }
    
    func setCard(card: Int) {
        front               = UIImage(named: "thaiLetter\(card)")!
        letterNumber        = card
        backgroundColor     = #colorLiteral(red: 0.9319444299, green: 0.805888474, blue: 0.5628086925, alpha: 1)
        image               = front
        isFlipped           = false
    }
}
