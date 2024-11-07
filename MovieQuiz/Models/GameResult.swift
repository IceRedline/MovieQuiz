//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Артем Табенский on 05.11.2024.
//

import Foundation

struct GameResult {
    let correctAnswers: Int
    let total: Int
    let date: Date
    
    func isBetter(_ another: GameResult) -> Bool {
        correctAnswers > another.correctAnswers
    }
}
