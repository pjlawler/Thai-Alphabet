//
//  CustomAlertVC.swift
//  Learn Thai Alphabet
//
//  Created by Patrick Lawler on 2/19/20.
//  Copyright © 2020 Patrick Lawler. All rights reserved.
//

import UIKit

enum InfoMessage {
    case tileGame
    case learnLettersBasic
    case learnLettersAdvanced
}


protocol MoreInfoMsgBoxVCDelegate {
    func okButtonTapped()
}


class MoreInfoMsgBoxVC: UIViewController {
    let containerView       = UIView()
    let titleLabel          = UILabel()
    let messageLabel        = UILabel()
    let actionButton        = ActionButton(title: "Okay")
    let padding: CGFloat    = 10
    let infoImageView       = UIImageView(frame: .zero)

    var message: InfoMessage?
    var delegate: MoreInfoMsgBoxVCDelegate?
    var messageText: String?
    
    
    init(message: InfoMessage) {
        super.init(nibName: nil, bundle: nil)
        self.message = message
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor    = UIColor.black.withAlphaComponent(0.75)
        messageText             = getInfoText()
        
        configureContainerView()
        configureTitleView()
        configureActionButton()
        configureBodyLabel()
    }
    
    
    func configureContainerView() {
        let largeConfig                     = UIImage.SymbolConfiguration(textStyle: .title1)
        let infoImage                       = UIImage(systemName: "info.circle", withConfiguration: largeConfig)
        let boxWidth                        = ScreenSize.width * 0.9 - padding * 2
        let boxHeight                       = getDynamicBoxHeight(text: messageText!, width: boxWidth)

        infoImageView.image                 = infoImage
        infoImageView.tintColor             = .white
        
        containerView.backgroundColor       = #colorLiteral(red: 0, green: 0.3573735952, blue: 0.4782596231, alpha: 1)
        containerView.layer.cornerRadius    = 16
        containerView.layer.borderWidth     = 2.0
        containerView.layer.borderColor     = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        view.addSubview(containerView)
        containerView.addSubview(infoImageView)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        infoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: boxHeight),
            containerView.widthAnchor.constraint(equalToConstant: boxWidth),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            infoImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            infoImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding)
        ])
    }
    
    
    func configureTitleView() {
        containerView.addSubview(titleLabel)
        
        titleLabel.text         = "Instructions"
        titleLabel.font         = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textColor    = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: infoImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: infoImageView.trailingAnchor, constant: padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    
    func configureActionButton() {
        containerView.addSubview(actionButton)
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            actionButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    
    func configureBodyLabel() {
        containerView.addSubview(messageLabel)

        messageLabel.text                       = messageText
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
            messageLabel.topAnchor.constraint(equalTo: infoImageView.bottomAnchor, constant: padding),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(greaterThanOrEqualTo: actionButton.topAnchor, constant: -padding)
        ])
    }
    
    @objc func dismissVC() {
        delegate?.okButtonTapped()
        dismiss(animated: true)
    }
}

extension  MoreInfoMsgBoxVC {
    
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
    
    
    func getInfoText() -> String {
        
        guard message != nil else { return "" }
        
        switch message {
        case .tileGame:
            return "Tap the respective tile of the Thai letter that the native speaker is saying. The correct tile will illuminate green whereas an incorrect tile will turn red.\n\nThe Grid Layout and Timer can be changed within the game's settings."
            
        case .learnLettersBasic:
            return "Answer the flashcard by saying the displayed Thai letter aloud.  Check your answer by tapping the Check button to listen to the native Thai speaker say the letter.  Swipe the flashcard to the right if you were correct; conversely swipe it to the left if you were wrong.\n\nMarking the flashcard as correct will remove the flashcard from the deck whereas incorrect cards will be randomly asked again later.\n\nThe deck of flashcards can be reset with the by tapping the more options menu."
            
        case .learnLettersAdvanced:
            return """
            Answer by writing the letter that is spoken on a separate piece of paper. To check your answer, tap the card to flip it over and reveal the correct letter. Then swipe the card right if your letter was correct or left if it was wrong.
            
            Answering correctly will remove the flashcard from the deck whereas incorrect cards will be randomly asked again later.
            
            The deck of flashcards can be reset with the by tapping the more options menu."
            """
            
        default:
            return ""
        }
        
    }
}
