//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Yura on 16.11.24.
//

import UIKit
import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
