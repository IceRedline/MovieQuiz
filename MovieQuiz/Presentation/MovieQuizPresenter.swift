//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Артем Табенский on 03.12.2024.
//

import UIKit

final class MovieQuizPresenter {
    
    private var currentQuestionIndex: Int = 0
    let questionsAmount: Int = 10
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func increaseQuestionIndex() {
        currentQuestionIndex += 1
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
    
    
    
}
