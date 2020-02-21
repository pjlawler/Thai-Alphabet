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
    
    
    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        configure()
    }
    
    
    func setButtonTitle(title: String) {
        self.setTitle(title, for: .normal)
    }
    
    private func configure() {
        setTitleColor(.white, for: .normal)
        setTitleColor(.systemGray2, for: .disabled)

        backgroundColor     = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 0.5)
        tintColor           = .black
        
        layer.borderColor   = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        layer.borderWidth   = 1
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 5, height: 5)
        layer.cornerRadius  = 15
        layer.shadowRadius  = 5.0
        layer.shadowOpacity = 1.0

        let width: CGFloat  = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 100 : 125
        
        translatesAutoresizingMaskIntoConstraints = false
            
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: width),
            self.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
