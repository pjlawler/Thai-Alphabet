//
//  FlashCard.swift
//  Learn Thai Alphabet
//
//  Created by Patrick Lawler on 2/18/20.
//  Copyright © 2020 Patrick Lawler. All rights reserved.
//

import UIKit

class FlashCard: UIImageView {
    var front           = UIImage()
    var back            = UIImage()
    var letterNumber    = 0
    var isFlipped       = false
    var audio           = SoundManager()
    
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
        backgroundColor                             = .white
        image                                       = front
        isFlipped                                   = false
        layer.borderWidth                           = 2.0
        layer.borderColor                           = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.shadowColor                           = UIColor.black.cgColor
        layer.shadowOffset                          = CGSize(width: 5, height: 5)
        layer.shadowRadius                          = 5.0
        layer.shadowOpacity                         = 1.0
    }
    
    
    func flip() {
        switch isFlipped {
        case true: flipBack()
        case false: flipForward()
        }
    }
    
    
    private func flipForward() {
        isFlipped = true
        backgroundColor = #colorLiteral(red: 0.9319444299, green: 0.805888474, blue: 0.5628086925, alpha: 1)
        audio.playSoundFX(.flip)
        UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromLeft, animations: { self.image = self.back }) { (done) in }
    }
    
    
    private func flipBack() {
        isFlipped = false
        backgroundColor     = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromLeft, animations: { self.image = self.front }) { (done) in }
    }
    
    
    func setCard(card: Int) {
        front               = UIImage(named: "cardBack")!
        back                = UIImage(named: "thaiLetterWithPicture\(card)")!
        letterNumber        = card
        backgroundColor     = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        image               = front
        isFlipped           = false
    }
}

