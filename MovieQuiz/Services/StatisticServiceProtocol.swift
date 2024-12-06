//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Yura on 22.11.24.
//

import UIKit
import Foundation

protocol StatisticServiceProtocol {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    
    func store(correct count: Int, total amount: Int)
}
