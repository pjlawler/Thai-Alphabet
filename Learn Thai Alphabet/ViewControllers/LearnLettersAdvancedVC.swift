//
//  FlashCardsVC.swift
//  Stack Practice
//
//  Created by Patrick Lawler on 2/14/20.
//  Copyright © 2020 Patrick Lawler. All rights reserved.
//

import UIKit

class LearnLettersAdvancedVC: UIViewController {
    
    let cardsRemaining      = TimerLabel()
    let buttonStack         = CustomStack(stackAxis: .horizontal, alignment: .fill, distribution: .fill, padding: 15)
    let scoreStack          = CustomStack(stackAxis: .horizontal, alignment: .fill, distribution: .fill, padding: 20)
    let sayAgainButton      = ActionButton(title: "Say Again")
    var cardGridStack       = CustomStack()
    let settingsButton      = SecondaryButton(normalImageName: "ellipsis.circle", selectedImageName: "")
    let informationButton   = SecondaryButton(normalImageName: "info.circle", selectedImageName: "")
    var flashCard           = FlashCard(frame: .zero)
    
    let audio               = SoundManager()
    
    let resultMark          = UIImageView()
    let checkmarkImage      = UIImage(named: "correctCheck")?.withRenderingMode(.alwaysTemplate)
    let wrongmarkImage      = UIImage(named: "wrongX")?.withRenderingMode(.alwaysTemplate)
    var cardBank            = Array(1...44)
    var answeredCorrect: Bool?
    var alert: UIAlertController!
    
    
    let infoAlert = MoreInfoMsgBoxVC(message: .learnLettersAdvanced)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackground()
        configureScoreboard()
        configureButtons()
        configureCard()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(false)
          cardBank.removeAll()
          let remainingCards  = PersistenceManager.loadAdvancedDeck()
          cardBank            = remainingCards != nil && remainingCards?.count != 0 ? remainingCards! : Array(1...44)
          displayCard(card: cardBank.randomElement()!)
      }
      
      override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(false)
          guard PersistenceManager.saveAdvancedDeck(cardBank: cardBank) == nil else {
              // TODO: Error Handler if unable to save to presets....
              return
          }
      }
      
    
    func configureBackground() {
        view.backgroundColor = #colorLiteral(red: 0, green: 0.3573735952, blue: 0.4782596231, alpha: 1)
    }
    
    
    func configureScoreboard() {
        let correctTitle    = ScoreboardTitleLabel()
        let timerTitle      = ScoreboardTitleLabel()
        let wrongTitle      = ScoreboardTitleLabel()
        let scoreStack      = CustomStack(stackAxis: .horizontal, alignment: .fill, distribution: .fill, padding: 20)
        
        view.addSubviews(views: scoreStack, correctTitle, timerTitle, wrongTitle)
        scoreStack.addArrangedSubview(cardsRemaining)
        
        timerTitle.text     = "Cards Remaining"
        
        NSLayoutConstraint.activate([
            scoreStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            scoreStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerTitle.bottomAnchor.constraint(equalTo: scoreStack.topAnchor),
            timerTitle.centerXAnchor.constraint(equalTo: cardsRemaining.centerXAnchor)
        ])
    }
    
    func configureButtons() {
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
    
    
    @objc func playButtonTapped() { audio.playCardTitle(cardNumber: flashCard.letterNumber) }
    
    
    @objc func moreOptionsButtonTapped() { displayMoreInfoMessage() }
    
    @objc func informationButtonTapped() {
        infoAlert.modalPresentationStyle    = .overFullScreen
        infoAlert.modalTransitionStyle      = .crossDissolve
        present(infoAlert, animated: true)
    }
    
    func displayMoreInfoMessage() {
        alert = nil
        alert = UIAlertController(title: "More Options...", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Back to Flashcards", style: .default, handler: { (done) in self.audio.playCardTitle(cardNumber: self.flashCard.letterNumber)}))
        alert.addAction(UIAlertAction(title: "Reset Flashcards", style: .default, handler: { (done) in self.resetDeck()}))
        alert.addAction(UIAlertAction(title: "Main Menu", style: .default, handler: { (done) in self.backToMain()}))
        self.present(alert, animated: true)
    }
    
    
    func backToMain() { navigationController?.popToRootViewController(animated: false) }
    
    
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
        
        let cardTappedGesure = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        let cardSwipedGesture = UIPanGestureRecognizer(target: self, action: #selector(cardSwiped(sender:)))
        
        flashCard.addGestureRecognizer(cardTappedGesure)
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
    
    @objc func cardTapped() {
        guard flashCard.isFlipped == false else { return }
        flashCard.flip()
    }
    
    
    @objc func cardSwiped(sender: UIPanGestureRecognizer) {
        guard flashCard.isFlipped else { return }
        guard let card              = sender.view else { return }
        
            
        let point                   = sender.translation(in: view)
        let isSwipingRight          = point.x > 0 ? true : false
        let cardCenterToEdge        = isSwipingRight ? (ScreenSize.width - view.center.x) - point.x : view.center.x + point.x
        let border: CGFloat         = 75
        let percentageToBorder      = abs(point.x) / (ScreenSize.width / 2 - border)
        let transformAngle: CGFloat = isSwipingRight ? percentageToBorder * 0.47 : percentageToBorder * -0.47
        let transformScale: CGFloat = 0.85 + ((1 - 0.85) * (1 - percentageToBorder) )
        
        card.center                 = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
    
        card.transform = CGAffineTransform(rotationAngle: transformAngle).scaledBy(x: transformScale, y: transformScale)
        
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
                card.center = self.view.center
                card.transform = CGAffineTransform(rotationAngle: 0)
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
        UIView.animate(withDuration: 0.5) {
            self.audio.playCardTitle(cardNumber: card)
            self.flashCard.alpha = 1 }
    }
    
    
    func displayEmptyDeckAlert() {
        cardsRemaining.text = "Empty"
        alert = UIAlertController(title: "Deck Empty", message: "Congratulations! You've successfully answered all of the flash cards!  Would you like play again or go back to the main menu?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { (done) in self.resetDeck() }))
        alert.addAction(UIAlertAction(title: "Main Menu", style: .default, handler: { (done) in self.backToMain()}))
        self.present(alert, animated: true)
    }
}
