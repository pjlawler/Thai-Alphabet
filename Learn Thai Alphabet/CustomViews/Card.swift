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
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 5, height: 5)
        layer.shadowRadius  = 5.0
        layer.shadowOpacity = 1.0
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
