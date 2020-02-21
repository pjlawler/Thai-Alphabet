//
//  SecondaryButton.swift
//  Stack Practice
//
//  Created by Patrick Lawler on 2/15/20.
//  Copyright © 2020 Patrick Lawler. All rights reserved.
//

import UIKit

class SecondaryButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(normalImageName: String, selectedImageName: String) {
        super.init(frame: .zero)
        let largeConfig     = UIImage.SymbolConfiguration(textStyle: .title1)
        let normalImage     = UIImage(systemName: normalImageName, withConfiguration: largeConfig)
        let selectedImage   = UIImage(systemName: selectedImageName, withConfiguration: largeConfig)
        self.setImage(normalImage, for: .normal)
        self.setImage(selectedImage, for: .selected)
        configure()
    }
    
    func configure() {
        tintColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        
    }
}
