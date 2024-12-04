//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Артем Табенский on 04.12.2024.
//

import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    
    var yesButton: UIButton! { get set }
    var noButton: UIButton! { get set }
    
    func show(quiz step: QuizStepViewModel)
    func showQuizResult(result: QuizResultsViewModel)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func highlightImageBorder(isCorrect: Bool)
    
    func showNetworkError(message: String)
    
    func disableButtons()
    
}
