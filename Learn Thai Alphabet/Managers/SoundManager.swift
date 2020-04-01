//
//  SoundManager.swift
//  Stack Practice
//
//  Created by Patrick Lawler on 2/5/20.
//  Copyright © 2020 Patrick Lawler. All rights reserved.
//

import Foundation
import AVFoundation

enum SFX {
    case dingCorrect
    case dingWrong
    case shuffle
    case flip
}

class SoundManager {
    
    var audioPlayer: AVAudioPlayer?
    func playSoundFX(_ soundFX: SFX) {
        var sound                   = ""
        switch soundFX {
        case .dingCorrect: sound    = "dingcorrect"
        case .dingWrong: sound      = "dingwrong"
        case .flip: sound           = "cardflip"
        case .shuffle: sound        = "shuffle"
        }
        
        
        let bundlePath              = Bundle.main.path(forResource: sound, ofType: "wav")
        let soundURL                = URL(fileURLWithPath: bundlePath!)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)

            audioPlayer             = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        }
        catch {
            print ("Couldn't get audioPlayer for file \(sound)")
        }
    }
    
    
    func playMakMak() {
        let bundlePath              = Bundle.main.path(forResource: "makmak", ofType: "m4a")
        guard bundlePath != nil else {
            print("Couldn't get path for file makmak")
            return
        }
        let soundURL                = URL(fileURLWithPath: bundlePath!)
        do {
            audioPlayer             = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
            self.audioPlayer?.play()
        }
        catch {
            print ("Couldn't get audioPlayer for file makmak")
        }
    }
    
    func playCardTitle(cardNumber: Int) {
        let soundFile               = "card\(cardNumber)Sound"
        let bundlePath              = Bundle.main.path(forResource: "\(soundFile)", ofType: "m4a")
        guard bundlePath != nil else {
            print("Couldn't get path for file \(String(describing: soundFile))")
            return
        }
        let soundURL                = URL(fileURLWithPath: bundlePath!)
        do {
            audioPlayer             = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
            self.audioPlayer?.play()
        }
        catch {
            print ("Couldn't get audioPlayer for file \(String(describing: soundFile))")
        }
    }
}
