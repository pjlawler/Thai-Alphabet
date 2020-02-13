//
//  ViewController.swift
//  Stack Practice
//
//  Created by Patrick Lawler on 2/5/20.
//  Copyright © 2020 Patrick Lawler. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var cardOne             = Card(frame: .zero)
    var cardTwo             = Card(frame: .zero)
    var cardThree           = Card(frame: .zero)
    var cardFour            = Card(frame: .zero)
    var cardFive            = Card(frame: .zero)
    var cardSix             = Card(frame: .zero)
    var cardSeven           = Card(frame: .zero)
    var cardEight           = Card(frame: .zero)
    var cardNine            = Card(frame: .zero)
    var cardTen             = Card(frame: .zero)
    var cardEleven          = Card(frame: .zero)
    var cardTwelve          = Card(frame: .zero)
    var cardThirteen        = Card(frame: .zero)
    var cardFourteen        = Card(frame: .zero)
    var cardFifteen         = Card(frame: .zero)
    var cardSixteen         = Card(frame: .zero)
    var cardSeventeen       = Card(frame: .zero)
    var cardEighteen        = Card(frame: .zero)
    var cardNineteen        = Card(frame: .zero)
    var cardTwenty          = Card(frame: .zero)
    var cardTwentyOne       = Card(frame: .zero)
    var cardTwentyTwo       = Card(frame: .zero)
    var cardTwentyThree     = Card(frame: .zero)
    var cardTwentyFour      = Card(frame: .zero)
    var cardTwentyFive      = Card(frame: .zero)
    var correctLabel        = ScoreLabel(type: .correct)
    var wrongLabel          = ScoreLabel(type: .wrong)
    var timerLabel          = ScoreLabel(type: .timer)
    var backgroundView      = UIImageView(image: UIImage(named: "bamboo"))
    var cardDeck: [Card]    = []
    let buttonStack         = UIStackView()
    let scoreStack          = UIStackView()
    let redealButton        = ActionButton(frame: .zero)
    let sayAgainButton      = ActionButton(frame: .zero)
    var numberOfCards       = 6
    var defaultLayout       = "4 X 3"
    let audio               = SoundManager()
    var answered            = false
    let correctDelay        = 0.75
    let wrongDelay          = 1.5
    var flippedTag: Int?
    var targetCard: Int!
    var timer: Timer?
    var timeAllowed         = 60
    var timeLeft            = 0
    var layoutOptions: [String]!
    var alert: UIAlertController!
    let formatter = NumberFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if DeviceTypes.isIphoneXAspectRatio() { defaultLayout = "4 X 4" }
        if DeviceTypes.isiPad { defaultLayout = "6 X 4" }
        setLayout(layout: defaultLayout)
        startGame()
        
    }
    
    
    func setLayout(layout: String) {
        let columns     = Utilites.columns(layout: layout)
        numberOfCards   = Utilites.totalCards(layout: layout)
        setupView(columns: columns)
    }
    
    
    func startGame() {
        if timer == nil {
            let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: .common)
            timer.tolerance = 0.1
            self.timer = timer
        }
        timeLeft            = timeAllowed
        correctLabel.text   = "0"
        wrongLabel.text     = "0"
        timerLabel.text     =  "\(timeAllowed)"
        dealRandomHand()
    }
    
    
    @objc func onTimerFires() {
        timeLeft -= 1
        if timeLeft <= 0 { gameOver() }
        timerLabel.text = timeLeft > 0 ? "\(timeLeft)" : "Game Over"
    }
    
    
    func dealRandomHand() {
        var numbersUsed: [Int] = []
        for card in 0...numberOfCards - 1 {
            var randomNumber: Int
            repeat {
                randomNumber = Int.random(in: 0...42) + 1
            } while numbersUsed.contains(randomNumber)
            numbersUsed.append(randomNumber)
            cardDeck[card].setCard(card: randomNumber)
        }
        targetCard  = numbersUsed[Int.random(in: 1...numbersUsed.count) - 1]
        flippedTag  = nil
        answered    = false
        audio.playCardTitle(cardNumber: targetCard)
    }
    
    
    func resetHand() {
        if answered == false { wrongLabel.text = Int(wrongLabel.text!) != nil ? String(Int(wrongLabel.text!)! + 1) : "0" }
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.dealRandomHand() }) { (done) in }
    }
    
    
    @objc func quitButtonTapped() { gameOver() }
    
    
    @objc func sayAgainButtonTapped() { audio.playCardTitle(cardNumber: targetCard) }
    
    
    @objc func cardTapped(sender: UITapGestureRecognizer) {
        
        guard let cardNumber = sender.view?.tag else { return }
        
        let tappedCard      = view.viewWithTag(cardNumber) as! Card
        let isCorrectCard   = targetCard == tappedCard.cardNum
        
        if tappedCard.isFlipped  == false && answered == false {
            if isCorrectCard { correctLabel.text = Int(correctLabel.text!) != nil ? String(Int(correctLabel.text!)! + 1) : "0" }
            else { wrongLabel.text = Int(wrongLabel.text!) != nil ? String(Int(wrongLabel.text!)! + 1) : "0" }
            answered = true
        }
        
        if flippedTag != nil {
            flipCardBackOver()
            if flippedTag == cardNumber {
                flippedTag = nil
                return
            }
        }
        
        flipCardUp(tappedCard: tappedCard, isCorrectCard: isCorrectCard)
        flippedTag = cardNumber
    }
    
    
    func flipCardUp(tappedCard: Card, isCorrectCard: Bool) {
        UIView.transition(with: tappedCard, duration: 0.3, options: .transitionFlipFromLeft, animations: {
            tappedCard.flip(number: self.targetCard)
        }) { (done) in
            if isCorrectCard {
                guard self.timeLeft > Int(self.correctDelay + 0.5) else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + self.correctDelay) {
                    if self.timeLeft < 0 { return }
                    self.resetHand()
                }
            }
            else {
                guard self.timeLeft > Int(self.wrongDelay + 0.5) else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + self.wrongDelay) {
                    if self.timeLeft < 0 { return }
                    self.audio.playCardTitle(cardNumber: self.targetCard)
                }
            }
        }
    }
    
    
    func flipCardBackOver() {
        let lastCard = view.viewWithTag(flippedTag!) as! Card
        UIView.transition(with: lastCard, duration: 0.3, options: .transitionFlipFromRight, animations: {
            lastCard.flip(number: nil)
        }, completion: nil)
    }
    
    
    func gameOver() {
        timer?.invalidate()
        timer = nil
        
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        
        let handsPlayed     = Int(correctLabel.text!) != nil && Int(wrongLabel.text!) != nil ? Int(correctLabel.text!)! + Int(wrongLabel.text!)! : 0
        let numberCorrect   = handsPlayed != 0 ? Int(correctLabel.text!)! : 0
        let accuracy        = numberCorrect != 0 && handsPlayed != 0 ? Double(numberCorrect) / Double(handsPlayed) : 0.0
        let score           = Double(numberCorrect) * 25000 * accuracy * Double(numberOfCards)  / Double(timeAllowed)
        
        formatter.maximumFractionDigits = 0
        let finalScore      = !score.isNaN ? formatter.string(from: NSNumber(value: score)) : "0"
        
        formatter.maximumFractionDigits = 1
        let finalAccuracy   = formatter.string(from: NSNumber(value: accuracy * 100))
        
        if accuracy == 1 && timeLeft == 0 { audio.playMakMak() }
        
        let title           = accuracy == 1 && timeLeft <= 0 ? "100% - You Win!" : "Game Over"
        let accuracyMessage = accuracy == 1 && timeLeft <= 0 ? "" : "\nYour accuracy is \(finalAccuracy!)%"
        
        alert = UIAlertController(title: title, message: "Score: \(finalScore!) points!\(accuracyMessage)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { (done) in
            self.startGame() }))
        alert.addAction(UIAlertAction(title: "Quit", style: .default, handler: { (done) in
            self.endGame() }))
        self.present(alert, animated: true)
    }
    
    
    func endGame() { exit(0) }
    
    
    func setupView(columns: Int) {
        view.backgroundColor        = .systemBackground
        cardDeck                    = [cardOne, cardTwo, cardThree, cardFour, cardFive, cardSix, cardSeven, cardEight, cardNine, cardTen, cardEleven, cardTwelve, cardThirteen, cardFourteen, cardFifteen, cardSixteen, cardSeventeen, cardEighteen, cardNineteen, cardTwenty, cardTwentyOne, cardTwentyTwo, cardTwentyThree, cardTwentyFour, cardTwentyFive]
        var cardCount               = 0
        let padding: CGFloat        = 10
        let viewWidth               = ScreenSize.width
        let cardRows                = numberOfCards / columns
        let cgColumns               = CGFloat(columns)
        let cardWidth: CGFloat      = (viewWidth - ((cgColumns + 1.0) * padding)) / cgColumns
        let cardHeight              = CGFloat(276.0 / 175.0) * cardWidth
        let verticalStack           = UIStackView()
        verticalStack.axis          = .vertical
        verticalStack.distribution  = .fillEqually
        verticalStack.alignment     = .fill
        verticalStack.spacing       = padding
        for _ in 1...numberOfCards / columns {
            let rowStack = UIStackView()
            rowStack.contentMode    = .scaleAspectFit
            rowStack.distribution   = .fillEqually
            rowStack.alignment      = .fill
            rowStack.axis           = .horizontal
            rowStack.spacing        = padding
            for _ in 1...columns {
                cardCount += 1
                let cardTappedGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped(sender:)))
                cardDeck[cardCount - 1].isUserInteractionEnabled = true
                cardDeck[cardCount - 1].addGestureRecognizer(cardTappedGesture)
                cardDeck[cardCount - 1].tag = cardCount
                cardDeck[cardCount - 1].frame = CGRect(x: 0, y: 0, width: cardWidth, height: cardHeight)
                rowStack.addArrangedSubview(cardDeck[cardCount - 1])
            }
            verticalStack.addArrangedSubview(rowStack)
        }
        verticalStack.translatesAutoresizingMaskIntoConstraints     = false
        scoreStack.translatesAutoresizingMaskIntoConstraints        = false
        buttonStack.translatesAutoresizingMaskIntoConstraints       = false
        backgroundView.translatesAutoresizingMaskIntoConstraints    = false
        backgroundView.contentMode                                  = .scaleAspectFill
        redealButton.setButtonTitle(title: "Quit")
        redealButton.addTarget(self, action: #selector(quitButtonTapped), for: .touchUpInside)
        sayAgainButton.setButtonTitle(title: "Repeat Letter")
        sayAgainButton.addTarget(self, action: #selector(sayAgainButtonTapped), for: .touchUpInside)
        scoreStack.addArrangedSubview(correctLabel)
        scoreStack.addArrangedSubview(timerLabel)
        scoreStack.addArrangedSubview(wrongLabel)
        scoreStack.axis             = .horizontal
        scoreStack.alignment        = .fill
        scoreStack.distribution     = .fill
        scoreStack.spacing          = 20
        buttonStack.addArrangedSubview(sayAgainButton)
        buttonStack.addArrangedSubview(redealButton)
        buttonStack.axis            = .horizontal
        buttonStack.alignment       = .fill
        buttonStack.distribution    = .fill
        buttonStack.spacing         = 15
        view.addSubview(backgroundView)
        view.addSubview(verticalStack)
        view.addSubview(scoreStack)
        view.addSubview(buttonStack)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scoreStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            scoreStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalStack.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: padding),
            verticalStack.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -padding),
            verticalStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            verticalStack.heightAnchor.constraint(equalToConstant: cardHeight * CGFloat(cardRows) + padding * CGFloat(cardRows + 2)),
            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            buttonStack.centerXAnchor.constraint(equalTo: verticalStack.centerXAnchor)
        ])
        view.layoutIfNeeded()
    }
}

