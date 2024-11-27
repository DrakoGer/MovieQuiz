//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Yura on 19.11.24.
//

import UIKit
import Foundation

<<<<<<< HEAD
final class AlertPresenter {
=======
class AlertPresenter {
>>>>>>> fa235488d6b1a71993fa1600a267981bba6be47d
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
    func showAlert(model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion?()
        }
        
        alert.addAction(action)

        viewController?.present(alert, animated: true)
    }
}
