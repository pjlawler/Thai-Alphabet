//
//  MainMenuVC.swift
//  Stack Practice
//
//  Created by Patrick Lawler on 2/17/20.
//  Copyright © 2020 Patrick Lawler. All rights reserved.
//

import UIKit
import AVFoundation

class MainMenuVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        configureBackground()
        configureMenu()
        let session = AVAudioSession()
        do { try session.setCategory(.playback) }
        catch {}
    }
    
    
    @objc func testButtonTapped() {
        let testVC = ProficiencyTestVC()
        transitionToAnotherView(to: testVC)
    }
    
    
    @objc func learnLettersBasic() {
        let learnBasic = LearnLettersBasic()
        transitionToAnotherView(to: learnBasic)
    }
    
    @objc func learnLettersAdvanced() {
        let learnAdvanced = LearnLettersAdvancedVC()
        transitionToAnotherView(to: learnAdvanced)
    }
    
    @objc func aboutButtonTapped() {
        let infoAlert = MoreInfoMsgBoxVC(message: .about)
        infoAlert.modalPresentationStyle    = .overFullScreen
        infoAlert.modalTransitionStyle      = .crossDissolve
        infoAlert.titleLabel.text           = "About"
        infoAlert.messageLabel.textAlignment    = .center
        
        
        present(infoAlert, animated: true)
    }
    
    
    func transitionToAnotherView(to view: UIViewController) {
        self.navigationController?.pushViewController(view, animated: false)
    }
    
    
    func configureMenu() {
        let menuStack               = CustomStack(stackAxis: .vertical, alignment: .fill, distribution: .fillEqually, padding: 25)
        let tileGame                = ActionButton(title: "Tile Game")
        let learnBasicButton        = ActionButton(title: "Learn Letters - Basic")
        let learnAdvancedButton     = ActionButton(title: "Learn Letters - Advanced")
        let aboutButton             = ActionButton(title: "About")
        
        
        tileGame.addTarget(self, action: #selector(testButtonTapped), for: .touchUpInside)
        learnBasicButton.addTarget(self, action: #selector(learnLettersBasic), for: .touchUpInside)
        learnAdvancedButton.addTarget(self, action: #selector(learnLettersAdvanced), for: .touchUpInside)
        aboutButton.addTarget(self, action: #selector(aboutButtonTapped), for: .touchUpInside)
        
        
        menuStack.addArrangedSubviews(views: learnBasicButton, learnAdvancedButton, tileGame, aboutButton)
        view.addSubview(menuStack)
        
        NSLayoutConstraint.activate([
            menuStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            menuStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            menuStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            menuStack.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    
    func configureBackground() {
        view.backgroundColor            = #colorLiteral(red: 0, green: 0.3573735952, blue: 0.4782596231, alpha: 1)
        let backgroundImageView         = UIImageView(image: UIImage(named: "background"))
        backgroundImageView.contentMode = .scaleAspectFit
        backgroundImageView.alpha       = 0.5
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backgroundImageView)

        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
