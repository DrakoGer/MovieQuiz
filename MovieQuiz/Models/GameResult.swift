//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Yura on 22.11.24.
//

import UIKit
import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ other: GameResult) -> Bool {
        correct > other.correct
    }
}
