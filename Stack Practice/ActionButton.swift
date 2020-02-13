//
//  ActionButton.swift
//  Stack Practice
//
//  Created by Patrick Lawler on 2/6/20.
//  Copyright © 2020 Patrick Lawler. All rights reserved.
//

import UIKit

class ActionButton: UIButton {

    var buttonTitle: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButtonTitle(title: String) {
        self.setTitle(title, for: .normal)
    }
    
    private func configure() {
        backgroundColor     = .systemBlue
        tintColor           = .white
        layer.borderColor   = UIColor.white.cgColor
        layer.borderWidth   = 1
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 5, height: 5)
        layer.shadowRadius  = 5.0
        layer.shadowOpacity = 1.0
       
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 125),
            self.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
