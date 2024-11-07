//
//  StatisticsService.swift
//  MovieQuiz
//
//  Created by Артем Табенский on 05.11.2024.
//

import Foundation

final class StatisticsService: StatisticServiceProtocol {
    
    private let storage: UserDefaults = .standard
    private var correctAnswers: Int {
        get {
            storage.integer(forKey: "totalCorrectAnswers")
        }
        set {
            storage.set(newValue, forKey: "totalCorrectAnswers")
        }
    }
    
    private enum Keys: String {
        case correct
        case bestGame
        case gamesCount
    }
    
    // благодаря геттеру и сеттеру при каждом изменении значения UserDefaults будут обновляться автоматически
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correctAnswers = storage.integer(forKey: "correctAnswers")
            let total = storage.integer(forKey: "total")
            let date = storage.object(forKey: "date") as? Date ?? Date()
            return GameResult(correctAnswers: correctAnswers, total: total, date: date)
        }
        set {
            storage.set(newValue.correctAnswers, forKey: "correctAnswers")
            storage.set(newValue.total, forKey: "total")
            storage.set(newValue.date, forKey: "date")
        }
    }
    
    var totalAccuracy: Double {
        Double(correctAnswers) / (10 * Double(gamesCount)) * 100
    }
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        correctAnswers += count
        let currentGame = GameResult(correctAnswers: count, total: amount, date: Date())
        if !bestGame.isBetter(currentGame) {
            bestGame = currentGame
        }
    }
}

