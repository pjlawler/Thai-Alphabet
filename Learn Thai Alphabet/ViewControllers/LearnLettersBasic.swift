//
//  LearnLettersVC.swift
//  Learn Thai Alphabet
//
//  Created by Patrick Lawler on 2/19/20.
//  Copyright © 2020 Patrick Lawler. All rights reserved.
//

import UIKit

class LearnLettersBasic: UIViewController {
    
    let cardsRemaining      = CardsRemainingLabel()
    var flashCard           = LearnLettersCard(frame: .zero)
    
    let audio               = SoundManager()
    
    let resultMark          = UIImageView()
    let checkmarkImage      = UIImage(named: "correctCheck")?.withRenderingMode(.alwaysTemplate)
    let wrongmarkImage      = UIImage(named: "wrongX")?.withRenderingMode(.alwaysTemplate)
    var cardBank            = Array(1...44)
    var cardChecked         = false
    var answeredCorrect: Bool?
    var alert: UIAlertController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackground()
        configureScoreboard()
        configureButtons()
        configureCard()
        displayCard(card: cardBank.randomElement()! )
    }
    
    
    func configureBackground() {
        view.backgroundColor = #colorLiteral(red: 0, green: 0.3573735952, blue: 0.4782596231, alpha: 1)
    }
    
    
    func configureScoreboard() {
        let cardsRemainingTitle = ScoreboardTitleLabel()
        let scoreStack          = CustomStack(stackAxis: .horizontal, alignment: .fill, distribution: .fill, padding: 20)
        
        view.addSubviews(views: scoreStack, cardsRemainingTitle)
        scoreStack.addArrangedSubview(cardsRemaining)
        
        cardsRemainingTitle.text     = "Cards Remaining"
        
        NSLayoutConstraint.activate([
            scoreStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            scoreStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardsRemainingTitle.bottomAnchor.constraint(equalTo: scoreStack.topAnchor),
            cardsRemainingTitle.centerXAnchor.constraint(equalTo: cardsRemaining.centerXAnchor)
        ])
    }
    
    
    func configureButtons() {
        let settingsButton      = SecondaryButton(normalImageName: "ellipsis.circle", selectedImageName: "")
        let informationButton   = SecondaryButton(normalImageName: "info.circle", selectedImageName: "")
        let sayAgainButton      = ActionButton(title: "Check")
        let buttonStack         = CustomStack(stackAxis: .horizontal, alignment: .fill, distribution: .fill, padding: 15)
        
        view.addSubviews(views:  buttonStack, settingsButton, informationButton)
        buttonStack.addArrangedSubview(sayAgainButton)
        
        let buttonPadding: CGFloat  = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 10 : 20
        
        NSLayoutConstraint.activate([
            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            settingsButton.centerYAnchor.constraint(equalTo: buttonStack.centerYAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -buttonPadding),
            informationButton.centerYAnchor.constraint(equalTo: buttonStack.centerYAnchor),
            informationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: buttonPadding)
        ])
        sayAgainButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(moreOptionsButtonTapped), for: .touchUpInside)
        informationButton.addTarget(self, action: #selector(informationButtonTapped), for: .touchUpInside)
    }
    
    
    @objc func playButtonTapped() {
        audio.playCardTitle(cardNumber: flashCard.letterNumber)
        cardChecked = true
    }
    
    
    @objc func moreOptionsButtonTapped() { displayMoreInfoMessage() }
    
    
    @objc func informationButtonTapped() {
        let infoAlert = MoreInfoMsgBoxVC(message: .learnLettersBasic)
        infoAlert.modalPresentationStyle    = .overFullScreen
        infoAlert.modalTransitionStyle      = .crossDissolve
        present(infoAlert, animated: true)
    }
    
    
    func displayMoreInfoMessage() {
        alert = nil
        alert = UIAlertController(title: "More Options...", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Back to Flashcards", style: .default))
        alert.addAction(UIAlertAction(title: "Reset Flashcards", style: .default, handler: { (done) in self.resetDeck()}))
        alert.addAction(UIAlertAction(title: "Main Menu", style: .default, handler: { (done) in self.backToMain()}))
        self.present(alert, animated: true)
    }
    
    
    func backToMain() { navigationController?.popToRootViewController(animated: false ) }
    
    
    func resetDeck() {
        cardBank.removeAll()
        cardBank.append(contentsOf: Array(1...44))
        audio.playSoundFX(.shuffle)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.displayCard(card: self.cardBank.randomElement()!) }
    }
    
    
    func configureCard() {
        
        view.addSubview(flashCard)
        flashCard.addSubview(resultMark)
        resultMark.translatesAutoresizingMaskIntoConstraints = false
        resultMark.alpha = 0.0
        
        let widthConstraint = ScreenSize.width * CGFloat(0.8)
        let heightConstraint = widthConstraint * CGFloat(276) / CGFloat(175)
        
        let cardSwipedGesture = UIPanGestureRecognizer(target: self, action: #selector(cardSwiped(sender:)))
        
        flashCard.addGestureRecognizer(cardSwipedGesture)
        NSLayoutConstraint.activate([
            flashCard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            flashCard.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            flashCard.widthAnchor.constraint(equalToConstant: widthConstraint),
            flashCard.heightAnchor.constraint(equalToConstant: heightConstraint),
            resultMark.centerXAnchor.constraint(equalTo: flashCard.centerXAnchor),
            resultMark.centerYAnchor.constraint(equalTo: flashCard.centerYAnchor),
            resultMark.widthAnchor.constraint(equalTo: flashCard.widthAnchor, multiplier: 0.75),
            resultMark.heightAnchor.constraint(equalTo: resultMark.widthAnchor)
        ])
    }
    
    
    @objc func cardSwiped(sender: UIPanGestureRecognizer) {
        guard cardChecked else { return }
        guard let card              = sender.view else { return }
        
        
        let point                   = sender.translation(in: view)
        let isSwipingRight          = point.x > 0 ? true : false
        let cardCenterToEdge        = isSwipingRight ? (ScreenSize.width - view.center.x) - point.x : view.center.x + point.x
        let border: CGFloat         = 75
        let percentageToBorder      = abs(point.x) / (ScreenSize.width / 2 - border)
        let transformAngle: CGFloat = isSwipingRight ? percentageToBorder * 0.47 : percentageToBorder * -0.47
        let transformScale: CGFloat = 0.85 + ((1 - 0.85) * (1 - percentageToBorder) )
        
        card.center                 = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        card.transform              = CGAffineTransform(rotationAngle: transformAngle).scaledBy(x: transformScale, y: transformScale)
        
        showResultMark(swipedRight: isSwipingRight, positionOfViewPrecentage: percentageToBorder)
        
        if sender.state == UIGestureRecognizer.State.ended {
            
            self.resultMark.alpha = 0
            
            if cardCenterToEdge < border {
                let distance: CGFloat = isSwipingRight ?  300 : -300
                answeredCorrect = isSwipingRight
                UIView.animate(withDuration: 0.5) { card.center = CGPoint(x: card.center.x + distance, y: card.center.y + 75) }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    card.alpha     = 0
                    card.transform = .identity
                    card.center    = self.view.center
                    self.getNextFlashCard()
                }
            }
            else { UIView.animate(withDuration: 0.3) {
                card.center     = self.view.center
                card.transform  = CGAffineTransform(rotationAngle: 0)
                }
            }
        }
    }
    
    
    func showResultMark(swipedRight: Bool, positionOfViewPrecentage: CGFloat) {
        switch swipedRight {
        case true:
            resultMark.image        = checkmarkImage
            resultMark.tintColor    = .systemGreen
        case false:
            resultMark.image        = wrongmarkImage
            resultMark.tintColor    = .systemRed
        }
        resultMark.alpha            = positionOfViewPrecentage
        answeredCorrect             = swipedRight
    }
    
    
    func getNextFlashCard() {
        guard  answeredCorrect != nil else { return }
        
        if answeredCorrect! {
            cardBank.removeAll(where: {$0 == flashCard.letterNumber})
            if cardBank.isEmpty {
                displayEmptyDeckAlert()
                return
            }
        }
        
        displayCard(card: cardBank.randomElement()!)
    }
    
    
    func displayCard(card: Int) {
        cardsRemaining.text = String(cardBank.count)
        flashCard.setCard(card: card)
        cardChecked = false
        UIView.animate(withDuration: 0.5) { self.flashCard.alpha = 1 }
    }
    
    
    func displayEmptyDeckAlert() {

        cardsRemaining.text = "Empty"
        flashCard.displayBlankCard()
        flashCard.alpha = 1
        let message = "Congratulations! You've successfully answered all of the flash cards!  Would you like play again or go back to the main menu?"
        
        let deckEmptyAlert = AlertMsgBoxVC(title: "Deck Empty", message: message, buttonTitles: ["Play Again", "Main Menu"])
          deckEmptyAlert.delegate = self
          deckEmptyAlert.modalPresentationStyle = .overFullScreen
          deckEmptyAlert.modalTransitionStyle = .crossDissolve
          present(deckEmptyAlert, animated: true)
    }
}

extension LearnLettersBasic: AlertMsgBoxProtocol {
    func buttonTapped(alert title: String, buttonTitle: String) {
        
        switch title {
        case "Deck Empty":
            if buttonTitle == "Play Again" { self.resetDeck() }
            if buttonTitle == "Main Menu" { self.backToMain() }
        default:
            return
        }
    }
    
    
}

