//
//  ProficiencyTestVC.swift
//  Stack Practice
//
//  Created by Patrick Lawler on 2/5/20.
//  Copyright © 2020 Patrick Lawler. All rights reserved.
//

import UIKit

class ProficiencyTestVC: UIViewController {
    
    let correctLabel        = ScoreLabel(type: .correct)
    let wrongLabel          = ScoreLabel(type: .wrong)
    let timerLabel          = TimerLabel()
    let buttonStack         = CustomStack(stackAxis: .horizontal, alignment: .fill, distribution: .fill, padding: 15)
    let scoreStack          = CustomStack(stackAxis: .horizontal, alignment: .fill, distribution: .fill, padding: 20)
    let passButton          = ActionButton(title: "Pass")
    let sayAgainButton      = ActionButton(title: "Say Again")
    var cardGridStack       = CustomStack()
    let settingsButton      = SecondaryButton(normalImageName: "ellipsis.circle", selectedImageName: "")
    let pauseButton         = SecondaryButton(normalImageName: "info.circle", selectedImageName: "")
    
    let formatter           = NumberFormatter()
    let audio               = SoundManager()
    let settingsVC          = TestSettingsVC()

    var cardTiles: [Card]   = []
    var correctCard: Card?
    var alert: UIAlertController!
    var numberOfCards: Int!
    var correctLetter: Int!
    var timeLeft: Int!
    var timer: Timer?
    var answered: Bool?
    
    var isPaused            = false
    var isPlayingAgain      = false
    var gridLayout          = "4 X 4"
    var timeAllowed         = 90
    let correctDelay        = 0.75
    let wrongDelay          = 1.5
    
    let infoAlert = MoreInfoMsgBoxVC(message: .tileGame)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoAlert.delegate = self
        configureBackground()
        configureScoreboard()
        configureButtons()
        configureCardGrid()
        startGame()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    
    func startGame() {
        if timer == nil {
            let timer       = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFiring), userInfo: nil, repeats: true)
            timer.tolerance = 0.1
            self.timer      = timer
            RunLoop.current.add(timer, forMode: .common)
        }
        timeLeft            = timeAllowed
        answered            = nil
        correctLabel.text   = "0"
        wrongLabel.text     = "0"
        dealRandomHand()
        audio.playCardTitle(cardNumber: self.correctLetter)
        unpauseGame()
    }
    
    
    func displayMoreInfoMessage() {
        pauseGame()
        alert = nil
        alert = UIAlertController(title: "More Options...", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (done) in
                 self.transitionToSettings() }))
        alert.addAction(UIAlertAction(title: "Main Menu", style: .default, handler: { (done) in self.endGame() }))
        alert.addAction(UIAlertAction(title: "Back to game", style: .default, handler: { (done) in
            self.audio.playCardTitle(cardNumber: self.correctLetter)
            self.unpauseGame() }))
        self.present(alert, animated: true)
    }
    
    
    @objc func onTimerFiring() {
        guard isPaused == false else { return }
        timeLeft -= 1
        if timeLeft <= 0 { resetGame(showStats: true) }
        updateTimeDisplay()
    }
    
    
    func currentTimer() -> String {
        let minutes                     = timeLeft < 60 ? 0 : timeLeft / 60
        let seconds                     = timeLeft - (minutes * 60)
        formatter.minimumIntegerDigits  = 2
        return formatter.string(from: NSNumber(value: minutes))! + ":" + formatter.string(from: NSNumber(value: seconds))!
    }
    
    
    func updateTimeDisplay() {
        guard !isPaused else { return }
        let timerDisplay    = currentTimer()
        timerLabel.text     = timeLeft > 0 ? "\(timerDisplay)" : "--:--"
    }
    
    
    func dealRandomHand() {
        if answered == false { wrongLabel.text = Int(wrongLabel.text!) != nil ? String(Int(wrongLabel.text!)! + 1) : "0" }
        buttonsOn()
        
        guard timeLeft > 0 else { return }
        
        let randomNumbers: [Int]    = Utilites.getRandomNonRepeatingIntArray(total: numberOfCards, from: 1, to: 44)
        for cardNumber in 1...self.numberOfCards { self.cardTiles[cardNumber - 1].setCard(card: randomNumbers[cardNumber - 1]) }
        answered                    = false
        correctCard                 = cardTiles.randomElement()
        correctLetter               = correctCard?.letterNumber
        if !isPaused { audio.playCardTitle(cardNumber: correctLetter) }
    }
    
    
    func pauseGame() {
        isPaused                    = true
        pauseButton.isSelected      = true
        timerLabel.text = "PAUSED"
        timerLabel.showPaused()
        buttonsOff()
        updateTimeDisplay()
    }
    
    
    func unpauseGame() {
        isPaused                    = false
        pauseButton.isSelected      = false
        timerLabel.showUnpaused()
        buttonsOn()
        updateTimeDisplay()
    }
    
    
    func buttonsOff() {
        for card in cardTiles { card.isUserInteractionEnabled = false }
        sayAgainButton.isEnabled    = false
        passButton.isEnabled = false
    }
    
    
    func buttonsOn() {
        for card in cardTiles { card.isUserInteractionEnabled = true }
        sayAgainButton.isEnabled    = true
        passButton.isEnabled = true
    }
    
    
    @objc func showButtonTapped() { revealCorrectCard() }
    
    
    @objc func sayAgainButtonTapped() { audio.playCardTitle(cardNumber: correctLetter) }
    
    
    @objc func moreOptionsButtonTapped() { displayMoreInfoMessage() }
    
    
    func transitionToSettings() {
        if !isPaused { pauseGame() }
        settingsVC.delegate             = self
        settingsVC.selectedMinutes      = timeAllowed / 60
        settingsVC.selectedSeconds      = timeAllowed - (timeAllowed / 60) * 60
        settingsVC.selectedLayout       = gridLayout
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    
    @objc func instructionsButtonTapped() {
        pauseGame()
        infoAlert.modalPresentationStyle    = .overFullScreen
        infoAlert.modalTransitionStyle      = .crossDissolve
        present(infoAlert, animated: true)
    }
    
    
    func revealCorrectCard() {
        buttonsOff()
        correctCard?.showAsCorrectCard()
        audio.playCardTitle(cardNumber: correctLetter)
        DispatchQueue.main.asyncAfter(deadline: .now() + self.wrongDelay) { self.dealRandomHand() }
    }
    
    
    @objc func cardTapped(sender: UITapGestureRecognizer) {
        guard let cardNumber    = sender.view?.tag else { return }
        answered                = true
        buttonsOff()
        
        let tappedCard          = view.viewWithTag(cardNumber) as! Card
        let isCorrectCard       = correctLetter == tappedCard.letterNumber
        if isCorrectCard {
            tappedCard.showAsCorrectCard()
            audio.playSoundFX(.dingCorrect)
            correctLabel.text = Int(correctLabel.text!) != nil ? String(Int(correctLabel.text!)! + 1) : "0"
        }
        else {
            tappedCard.showAsWrongCard()
            audio.playSoundFX(.dingWrong)
            wrongLabel.text = Int(wrongLabel.text!) != nil ? String(Int(wrongLabel.text!)! + 1) : "0"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + self.correctDelay) { self.dealRandomHand() }
    }
    
    
    func displayGameStats() {
        let handsPlayed                 = Int(correctLabel.text!) != nil && Int(wrongLabel.text!) != nil ? Int(correctLabel.text!)! + Int(wrongLabel.text!)! : 0
        let numberCorrect               = handsPlayed != 0 ? Int(correctLabel.text!)! : 0
        let accuracy                    = numberCorrect != 0 && handsPlayed != 0 ? Double(numberCorrect) / Double(handsPlayed) : 0.0
        let score                       = Double(numberCorrect) * 1000 * accuracy * pow(Double(numberOfCards - 1), 2.0)  / Double(timeAllowed)

        formatter.numberStyle           = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        let finalScore                  = !score.isNaN ? formatter.string(from: NSNumber(value: score)) : "0"
        
        formatter.maximumFractionDigits = 1
        let finalAccuracy               = formatter.string(from: NSNumber(value: accuracy * 100))
        
        if accuracy == 1 && timeLeft == 0 { audio.playMakMak() }
        let title                       = accuracy == 1 && timeLeft <= 0 ? "100% - You Win!" : "Game Over"
        let accuracyMessage             = accuracy == 1 && timeLeft <= 0 ? "" : "\nYour accuracy is \(finalAccuracy!)%"
        
        alert                           = UIAlertController(title: title, message: "Score: \(finalScore!) points!\(accuracyMessage)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { (done) in
            self.isPlayingAgain = true
            self.startGame() }))
        alert.addAction(UIAlertAction(title: "Quit", style: .default, handler: { (done) in self.endGame() }))
        self.present(alert, animated: true)
    }
    
    
    func resetGame(showStats: Bool) {
        timer?.invalidate()
        timer = nil
        if showStats { displayGameStats() }
        else { startGame() }
    }
    
    
    func endGame() {
        timer?.invalidate()
        timer = nil
        navigationController?.popToRootViewController(animated: false ) }
    
    
    func configureBackground() {
        view.backgroundColor = #colorLiteral(red: 0, green: 0.3573735952, blue: 0.4782596231, alpha: 1)
    }
    
    
    func configureButtons() {
        view.addSubviews(views: pauseButton, buttonStack, settingsButton)
        buttonStack.addArrangedSubviews(views: sayAgainButton, passButton)

        let buttonPadding: CGFloat  = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 10 : 20

        NSLayoutConstraint.activate([
            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            settingsButton.centerYAnchor.constraint(equalTo: buttonStack.centerYAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -buttonPadding),
            pauseButton.centerYAnchor.constraint(equalTo: buttonStack.centerYAnchor),
            pauseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: buttonPadding)
        ])
        
        passButton.addTarget(self, action: #selector(showButtonTapped), for: .touchUpInside)
        sayAgainButton.addTarget(self, action: #selector(sayAgainButtonTapped), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(moreOptionsButtonTapped), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(instructionsButtonTapped), for: .touchUpInside)
    }
    
    
    func configureScoreboard() {
        let correctTitle        = ScoreboardTitleLabel()
        let wrongTitle          = ScoreboardTitleLabel()
        let timerTitle          = ScoreboardTitleLabel()
        
        view.addSubviews(views: scoreStack, correctTitle, timerTitle, wrongTitle)
        scoreStack.addArrangedSubviews(views: wrongLabel, timerLabel, correctLabel)
        
        correctTitle.text   = "Correct"
        wrongTitle.text     = "Wrong"
        timerTitle.text     = "Timer"
        
        NSLayoutConstraint.activate([
            scoreStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            scoreStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            correctTitle.bottomAnchor.constraint(equalTo: scoreStack.topAnchor),
            correctTitle.centerXAnchor.constraint(equalTo: correctLabel.centerXAnchor),
            timerTitle.bottomAnchor.constraint(equalTo: scoreStack.topAnchor),
            timerTitle.centerXAnchor.constraint(equalTo: timerLabel.centerXAnchor),
            wrongTitle.bottomAnchor.constraint(equalTo: scoreStack.topAnchor),
            wrongTitle.centerXAnchor.constraint(equalTo: wrongLabel.centerXAnchor)
        ])
    }
    
    
    func configureCardGrid() {
        cardGridStack.removeFromSuperview()
        cardTiles.removeAll()
        
        let columns             = Utilites.columns(layout: gridLayout)
        numberOfCards           = Utilites.totalCards(layout: gridLayout)
        
        for _ in 1...numberOfCards {
            let card = Card(frame: .zero)
            cardTiles.append(card)
        }
        
        let cardRows            = numberOfCards / columns
        let padding: CGFloat    = 10
        cardGridStack           = generateCardGrid(of: cardTiles, rows: cardRows, columns: columns, with: padding)
        view.addSubview(cardGridStack)
        
        NSLayoutConstraint.activate([
            cardGridStack.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: padding),
            cardGridStack.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -padding),
            cardGridStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardGridStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardGridStack.topAnchor.constraint(greaterThanOrEqualTo: scoreStack.bottomAnchor, constant: padding),
            cardGridStack.bottomAnchor.constraint(lessThanOrEqualTo: buttonStack.topAnchor, constant: -padding),
        ])
    }
    
    
    func generateCardGrid(of cardTiles: [Card], rows: Int, columns: Int, with padding: CGFloat) -> CustomStack {
        var cardIndex               = 0
        let verticalStack           = CustomStack(stackAxis: .vertical, alignment: .fill, distribution: .fillEqually, padding: padding)
        for _ in 1...rows {
            let rowStack = CustomStack(stackAxis: .horizontal, alignment: .fill, distribution: .fillEqually, padding: padding)
            rowStack.contentMode = .scaleAspectFill
            for _ in 1...columns {
                let cardTappedGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped(sender:)))
                cardTiles[cardIndex].addGestureRecognizer(cardTappedGesture)
                cardTiles[cardIndex].isUserInteractionEnabled = true
                cardTiles[cardIndex].tag = cardIndex + 1
                rowStack.addArrangedSubview(cardTiles[cardIndex])
                cardIndex += 1
            }
            verticalStack.addArrangedSubview(rowStack)
        }
        return verticalStack
    }
}

extension ProficiencyTestVC: TestSettingsProtocol {

    func settingsChanged() {
        gridLayout  = settingsVC.selectedLayout
        timeAllowed = settingsVC.selectedMinutes * 60 + settingsVC.selectedSeconds
        unpauseGame()
        configureCardGrid()
        resetGame(showStats: false)
    }
}

extension ProficiencyTestVC: MoreInfoMsgBoxVCDelegate {
    
    func okButtonTapped() {
        audio.playCardTitle(cardNumber: correctCard!.letterNumber)
        unpauseGame()
    }
}

