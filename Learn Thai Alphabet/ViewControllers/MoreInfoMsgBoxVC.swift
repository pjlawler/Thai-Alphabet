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

    let containerView = UIView()
    let titleLabel = UILabel()
    let messageLabel = UILabel()
    let actionButton = ActionButton(title: "Okay")
    let padding: CGFloat = 20
    
    var message: InfoMessage?
    
    var delegate: MoreInfoMsgBoxVCDelegate?
    let infoImageView   = UIImageView(frame: .zero)
    
    init(message: InfoMessage) {
        super.init(nibName: nil, bundle: nil)
        self.message        = message
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        configureContainerView()
        configureTitleView()
        configureActionButton()
        configureBodyLabel()
        
    }
    
    
    func configureContainerView() {
        let largeConfig     = UIImage.SymbolConfiguration(textStyle: .title1)
        let infoImage       = UIImage(systemName: "info.circle", withConfiguration: largeConfig)
        
        infoImageView.image = infoImage
        infoImageView.tintColor = .white
        

        view.addSubview(containerView)
        containerView.backgroundColor       = #colorLiteral(red: 0, green: 0.3573735952, blue: 0.4782596231, alpha: 1)
        containerView.layer.cornerRadius    = 16
        containerView.layer.borderWidth     = 2.0
        containerView.layer.borderColor     = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(infoImageView)
        
        infoImageView.translatesAutoresizingMaskIntoConstraints = false

        
        let boxHeight: CGFloat = message == .tileGame ? 300 : 450
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: boxHeight),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            infoImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            infoImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10)
        ])
    }
    
    func configureTitleView() {
        containerView.addSubview(titleLabel)
        
        titleLabel.text = "More Info"
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: infoImageView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }
    
    func configureActionButton() {
        containerView.addSubview(actionButton)
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            actionButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    
    func configureBodyLabel() {
        containerView.addSubview(messageLabel)
        messageLabel.text = getInfoText()
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.preferredFont(forTextStyle: .body)
        messageLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            messageLabel.bottomAnchor.constraint(greaterThanOrEqualTo: actionButton.topAnchor, constant: 8)
        ])
        
           
    }
    
    
   
    @objc func dismissVC() {
        delegate?.okButtonTapped()
        dismiss(animated: true)
    }

}

extension  MoreInfoMsgBoxVC {
    
    func getInfoText() -> String {
        
        guard message != nil else { return "" }
        
        switch message {
        case .tileGame:
            return "Tap the respective tile of the Thai letter that the native speaker is saying. The correct tile will illuminate green whereas an incorrect tile will turn red.\n\nThe Grid Layout and Timer can be changed within the game's settings."
        case .learnLettersBasic:
            return "Answer the flashcard by saying the displayed Thai letter outloud.  Check your answer for the correct letter and pronounciation by listeniing to the native Thai speaker.  Then swipe the card right if you were correct or left if you were wrong.\n\nAnswering correctly will remove the flashcard from the deck whereas incorrect letters will be asked again later.\n\nThe deck of flashcards can be reset with the by tapping the more options menu."
        case .learnLettersAdvanced:
            return "Practice by writing the letter that is spoken on a separte piece of paper. To check your answer, tap the card to flip the card over which will reveal the correct letter.  Then swipe the card right if you were correct or left if you were wrong.\n\nAnswering correctly will remove the flashcard from the deck whereas incorrect letters will be asked again later.\n\nThe deck of flashcards can be reset with the by tapping the more options menu."
        default:
            return ""
        }
        
    }
    
    
}
