//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Артем Табенский on 01.11.2024.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    
    private var moviesLoader: MoviesLoading
    weak var delegate: QuestionFactoryDelegate?
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func setup(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    private var movies: [MostPopularMovie] = []
    
    func loadData() {
        moviesLoader.loadMovies() { [weak self] result in
            
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.imageURL)
            } catch {
                print("Failed to load movie image")
            }
            
            let rating = Float(movie.rating) ?? 0
            
            let ratingRange = Array(stride(from: 8.0, through: 9.2, by: 0.2))
            guard let numberToCompare = ratingRange.randomElement() else { return }
            guard let actionToCompare = ["больше", "меньше"].randomElement() else { return }
            
            let text = "Рейтинг этого фильма \(actionToCompare) чем \(numberToCompare)?"
            let correctAnswer = actionToCompare == "больше" ? rating > Float(numberToCompare) : rating < Float(numberToCompare)
            
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}
