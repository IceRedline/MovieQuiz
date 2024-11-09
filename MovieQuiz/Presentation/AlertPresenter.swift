//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Артем Табенский on 02.11.2024.
//

import UIKit

final class AlertPresenter {
    
    weak var viewController: UIViewController?
    
    func show(with model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default,
            handler: { _ in
                model.completion()
            }
        )
        alert.addAction(action)
        viewController?.present(alert, animated: true)
    }
}
