//
//  Card.swift
//  Stack Practice
//
//  Created by Patrick Lawler on 2/5/20.
//  Copyright © 2020 Patrick Lawler. All rights reserved.
//

import UIKit


class Card: UIImageView {
    var front       = UIImage()
    var back        = UIImage()
    var cardNum     = 0
    var isFlipped   = false
    let sound       = SoundManager()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        backgroundColor     = .systemBlue
        image               = front
        isFlipped           = false
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 5, height: 5)
        layer.shadowRadius  = 5.0
        layer.shadowOpacity = 1.0
    }
    
    
    func setCard(card: Int) {
        front               = UIImage(named: "alphafront\(card)")!
        back                = UIImage(named: "alphaback\(card)")!
        cardNum             = card
        backgroundColor     = .systemBlue
        image               = front
        isFlipped           = false
    }
    
    
    func flip(number: Int?) {
        sound.playSoundFX(.flip)
        if isFlipped {
            backgroundColor = .systemBlue
            image           = front
            isFlipped       = false
        }
        else {
            guard number != nil else { return }
            backgroundColor = number == cardNum ? .systemGreen : .systemRed
            image           = back
            isFlipped       = true
            if number != cardNum { sound.playCardTitle(cardNumber: cardNum) }
            else { sound.playSoundFX(.dingCorrect) }
        }
    }
}
