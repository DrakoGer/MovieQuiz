//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Yura on 19.11.24.
//

import UIKit
import Foundation

final class AlertPresenter {
    
    func showAlert(on viewController: UIViewController, with model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        alert.view.accessibilityIdentifier = model.title
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion?()
        }
        action.accessibilityIdentifier = model.buttonText
        
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
}
