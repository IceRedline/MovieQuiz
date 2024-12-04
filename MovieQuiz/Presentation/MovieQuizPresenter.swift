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
    
    private weak var viewController: MovieQuizViewControllerProtocol?
    private let statisticService: StatisticServiceProtocol!
    var questionFactory: QuestionFactoryProtocol?
    var currentQuestion: QuizQuestion?
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        statisticService = StatisticsServiceImplementation()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    func increaseQuestionIndex() {
        currentQuestionIndex += 1
    }
    
    internal func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
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
        viewController?.hideLoadingIndicator()
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
        proceedWithAnswer(isCorrect: isCorrect)
    }
    
    func yesButtonTapped() {
        checkAnswer(isYes: true)
        viewController?.disableButtons()
    }
    
    func noButtonTapped() {
        checkAnswer(isYes: false)
        viewController?.disableButtons()
    }
    
    private func proceedWithAnswer(isCorrect: Bool) {
        viewController?.highlightImageBorder(isCorrect: isCorrect)
        correctAnswers += isCorrect ? 1 : 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            proceedToNextQuestionOrResults()
        }
    }
    
    // Проверить последний вопрос или нет
    private func proceedToNextQuestionOrResults() {

        if self.isLastQuestion() {
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            let result = "Ваш результат: \(correctAnswers)/10"
            let quizes = "Количество сыгранных квизов: \(statisticService?.gamesCount ?? 0)"
            let record = "Рекорд: \(statisticService?.bestGame.correctAnswers ?? 0)/10 (\(statisticService?.bestGame.date.dateTimeString ?? "no date"))"
            let accuracy = "Средняя точность: \(String(format: "%.2f", statisticService?.totalAccuracy ?? 0))%"
            let text = "\(result) \n \(quizes) \n \(record) \n \(accuracy)"
            
            let resultViewModel = QuizResultsViewModel(title: "Этот раунд окончен!", text: text, buttonText: "Сыграть еще раз")
            viewController?.showQuizResult(result: resultViewModel)
        } else {
            self.increaseQuestionIndex()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        viewController?.showLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
}
