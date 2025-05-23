//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Артем Табенский on 02.11.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
