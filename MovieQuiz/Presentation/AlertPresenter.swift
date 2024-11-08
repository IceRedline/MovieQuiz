//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Артем Табенский on 02.11.2024.
//

import UIKit

final class AlertPresenter {
    
    weak var viewController: UIViewController?
    func show(quiz result: QuizResultsViewModel, model: AlertModel, on vc: UIViewController) {
        let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
        let action = UIAlertAction(title: "Сыграть еще раз", style: .default) { _ in
            model.completion()
        }
        alert.addAction(action)
        vc.present(alert, animated: true)
    }
}
