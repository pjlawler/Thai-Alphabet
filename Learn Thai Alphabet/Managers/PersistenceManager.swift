//
//  PersistenceManager.swift
//  Learn Thai Alphabet
//
//  Created by Patrick Lawler on 3/29/20.
//  Copyright © 2020 Patrick Lawler. All rights reserved.
//

import Foundation

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let basicDeck        = "basicDeck"
        static let advancedDeck     = "advancedDeck"
    }
    
    
    static func loadBasicDeck() -> [Int]? {
        guard let deckData = defaults.object(forKey: Keys.basicDeck) as? Data else { return nil }
        
        let decoder = JSONDecoder()
        do {
            let deck = try decoder.decode([Int].self, from: deckData)
            return deck
            
        } catch {
            return nil
        }
    }
    
    
    static func saveBasicDeck(cardBank: [Int]) -> Error? {
        do {
            let encoder = JSONEncoder()
            let cardsRemaining  = try encoder.encode(cardBank)
            defaults.setValue(cardsRemaining, forKey: Keys.basicDeck)
            return nil
        } catch {
            return error
        }
    }
    
    
    static func loadAdvancedDeck() -> [Int]? {
        guard let deckData = defaults.object(forKey: Keys.advancedDeck) as? Data else { return nil }
        
        let decoder = JSONDecoder()
        do {
            let deck = try decoder.decode([Int].self, from: deckData)
            return deck
            
        } catch {
            return nil
        }
    }
    
    
    static func saveAdvancedDeck(cardBank: [Int]) -> Error? {
        do {
            let encoder = JSONEncoder()
            let cardsRemaining  = try encoder.encode(cardBank)
            defaults.setValue(cardsRemaining, forKey: Keys.advancedDeck)
            return nil
        } catch {
            return error
        }
    }
    
    
    
}
