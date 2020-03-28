//
//  AlertMsgBoxVC.swift
//  Learn Thai Alphabet
//
//  Created by Patrick Lawler on 2/22/20.
//  Copyright © 2020 Patrick Lawler. All rights reserved.
//

import UIKit

protocol AlertMsgBoxProtocol {
    func buttonTapped(alert title: String, buttonTitle: String)
}


class AlertMsgBoxVC: UIViewController {
    
    var alertTitle: String!
    var message: String!
    var buttonTitles: [String]!
    var delegate: AlertMsgBoxProtocol?
    
    let containerView       = UIView()
    var padding: CGFloat    = 10

    let alertImageView      = UIImageView(frame: .zero)

    
    
    init(title: String, message: String, buttonTitles: [String]?) {
        super.init(nibName: nil, bundle: nil)
        
        self.alertTitle   = title
        self.message        = message
        self.buttonTitles   = buttonTitles != nil ? buttonTitles : ["Ok"]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor    = UIColor.black.withAlphaComponent(0.75)
        configureContainerView()
        configureTitleView()
        configureButtons()
        configureBodyLabel()
    }
    
    func configureContainerView() {
        
        
        let largeConfig                     = UIImage.SymbolConfiguration(textStyle: .title1)
        let infoImage                       = UIImage(systemName: "exclamationmark.circle", withConfiguration: largeConfig)
        let boxWidth                        = ScreenSize.width * 0.9 - padding * 2
        let boxHeight                       = getDynamicBoxHeight(text: message, width: boxWidth)
        
        alertImageView.image                 = infoImage
        alertImageView.tintColor             = .white
        
        containerView.backgroundColor       = #colorLiteral(red: 0, green: 0.3573735952, blue: 0.4782596231, alpha: 1)
        containerView.layer.cornerRadius    = 16
        containerView.layer.borderWidth     = 2.0
        containerView.layer.borderColor     = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        view.addSubview(containerView)
        containerView.addSubview(alertImageView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        alertImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: boxHeight),
            containerView.widthAnchor.constraint(equalToConstant: boxWidth),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            alertImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding)
        ])
    }
    
    func configureTitleView() {
        let titleLabel          = UILabel()
        titleLabel.text         = alertTitle
        titleLabel.font         = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textColor    = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: alertImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: alertImageView.trailingAnchor, constant: padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configureButtons() {
                
        let buttonStack = CustomStack(stackAxis: .horizontal, alignment: .fill, distribution: .fill, padding: 15)
        
        view.addSubview(buttonStack)
        
        for buttonTitle in buttonTitles {
            let button = ActionButton(title: buttonTitle)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            buttonStack.addArrangedSubview(button)
        }
        
        NSLayoutConstraint.activate([
            buttonStack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant:  -20),
            buttonStack.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    
    func configureBodyLabel() {
        let messageLabel = UILabel()
          containerView.addSubview(messageLabel)

          messageLabel.text                       = message
          messageLabel.minimumScaleFactor         = 0.3
          messageLabel.numberOfLines              = 0
          messageLabel.font                       = UIFont.preferredFont(forTextStyle: .body)
          messageLabel.adjustsFontSizeToFitWidth  = true
          messageLabel.textColor                  = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
          messageLabel.lineBreakMode              = .byWordWrapping
          messageLabel.textAlignment              = .justified

          messageLabel.translatesAutoresizingMaskIntoConstraints = false
          messageLabel.sizeToFit()
          
          NSLayoutConstraint.activate([
              messageLabel.topAnchor.constraint(equalTo: alertImageView.bottomAnchor, constant: padding),
              messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
              messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
              messageLabel.bottomAnchor.constraint(greaterThanOrEqualTo: alertImageView.topAnchor, constant: -padding)
          ])
      }
}

extension AlertMsgBoxVC {
    
    func getDynamicBoxHeight(text: String, width: CGFloat) -> CGFloat {
           
           let minSize: CGFloat    = 155
           let label               = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
           label.numberOfLines     = 0
           label.font              = UIFont.preferredFont(forTextStyle: .body)
           label.text              = text
           label.lineBreakMode     = .byWordWrapping
           label.textAlignment     = .justified
           label.sizeToFit()

           let labelHeight         = label.frame.height
           let boxHeight = min(labelHeight + minSize, ScreenSize.height - minSize)
           
           return boxHeight
       }
    
    @objc func buttonTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        dismiss(animated: true) {
            self.delegate?.buttonTapped(alert: self.alertTitle, buttonTitle: buttonTitle)
        }
    }
    
}
