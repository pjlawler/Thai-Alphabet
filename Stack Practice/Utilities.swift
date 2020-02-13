//
//  Utilities.swift
//  Stack Practice
//
//  Created by Patrick Lawler on 2/11/20.
//  Copyright © 2020 Patrick Lawler. All rights reserved.
//

import Foundation


struct Utilites {
    
    static func totalCards(layout: String) -> Int {
        let numbers = layout.split(separator: "X")
        let columns = Int(String(numbers[0]).replacingOccurrences(of: " ", with: ""))!
        let rows    = Int(String(numbers[1]).replacingOccurrences(of: " ", with: ""))!
        return   columns * rows
    }
    
    static func columns(layout: String) -> Int {
        let numbers = layout.split(separator: "X")
        let columns = Int(String(numbers[0]).replacingOccurrences(of: " ", with: ""))!
        return columns
    }
    
}
