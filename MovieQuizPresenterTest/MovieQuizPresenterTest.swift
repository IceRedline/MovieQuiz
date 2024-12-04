//
//  MovieQuizPresenterTest.swift
//  MovieQuizPresenterTest
//
//  Created by Артем Табенский on 04.12.2024.
//

import XCTest

@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    var yesButton: UIButton!
    
    var noButton: UIButton!
    
    func disableButtons() {
        
    }
    
    func show(quiz step: QuizStepViewModel) {
        
    }
    
    func showQuizResult(result: QuizResultsViewModel) {
        
    }
    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
    func highlightImageBorder(isCorrect: Bool) {
        
    }
    
    func showNetworkError(message: String) {
        
    }
    
}


final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
} 
