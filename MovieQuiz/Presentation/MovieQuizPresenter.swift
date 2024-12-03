//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Артем Табенский on 03.12.2024.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private var currentQuestionIndex: Int = 0
    let questionsAmount: Int = 10
    var correctAnswers = 0
    
    weak var viewController: MovieQuizViewController?
    var statisticService: StatisticService?
    var questionFactory: QuestionFactoryProtocol = QuestionFactory(moviesLoader: MoviesLoader(), delegate: nil)
    var currentQuestion: QuizQuestion?
    
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func increaseQuestionIndex() {
        currentQuestionIndex += 1
    }
    
    internal func didLoadDataFromServer() {
        questionFactory.requestNextQuestion()
    }
    
    internal func didFailToLoadData(with error: any Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    // Конвертировать моковый вопрос и вернуть вью модель для экрана вопроса
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        return QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        viewController?.loadingIndicator.stopAnimating()
        guard let question = question else {
            return
        }

        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }

    }
    
    private func checkAnswer(isYes: Bool) {
        viewController?.yesButton.isEnabled = false
        viewController?.noButton.isEnabled = false
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        let isCorrect = currentQuestion.correctAnswer == isYes
        viewController?.showAnswerResult(isCorrect: isCorrect)
    }
    
    func yesButtonTapped() {
        checkAnswer(isYes: true)
        viewController?.disableButtons()
    }
    
    func noButtonTapped() {
        checkAnswer(isYes: false)
        viewController?.disableButtons()
    }
    
    // Проверить последний вопрос или нет
    func showNextQuestionOrResults() {

        if self.isLastQuestion() {
            statisticService?.store(correct: correctAnswers, total: self.questionsAmount)
            let result = "Ваш результат: \(correctAnswers)/10"
            let quizes = "Количество сыгранных квизов: \(statisticService?.gamesCount ?? 0)"
            let record = "Рекорд: \(statisticService?.bestGame.correctAnswers ?? 0)/10 (\(statisticService?.bestGame.date.dateTimeString ?? "no date"))"
            let accuracy = "Средняя точность: \(String(format: "%.2f", statisticService?.totalAccuracy ?? 0))%"
            let text = "\(result) \n \(quizes) \n \(record) \n \(accuracy)"
            
            let resultViewModel = QuizResultsViewModel(title: "Этот раунд окончен!", text: text, buttonText: "Сыграть еще раз")
            viewController?.showQuizResult(result: resultViewModel)
        } else {
            self.increaseQuestionIndex()
            questionFactory.requestNextQuestion()
        }
    }
    
}
