//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Yura on 11.12.24.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private let statisticService: StatisticServiceProtocol!
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewControllerProtocol?
    
    
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount = 10

    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        self.statisticService = StatisticService()

        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }

    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }

        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }

    func yesButtonClicked() {
        proceedWithAnswer(isYes: true)
    }

    func noButtonClicked() {
        proceedWithAnswer(isYes: false)
    }

    private func proceedWithAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }

        let givenAnswer = isYes
        let isCorrect = givenAnswer == currentQuestion.correctAnswer

        didAnswer(isCorrectAnswer: isCorrect)
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.proceedToNextQuestionOrResults()
        }
    }

    private func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }

    private func proceedToNextQuestionOrResults() {
        if isLastQuestion() {
            let resultMessage = makeResultsMessage()
            let resultViewModel = QuizResultViewModel(
                title: "Этот раунд окончен!",
                text: resultMessage,
                buttonText: "Сыграть ещё раз"
            )
            viewController?.show(quiz: resultViewModel)
        } else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }

    private func isLastQuestion() -> Bool {
        return currentQuestionIndex == questionsAmount - 1
    }

    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }

    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }

    func makeResultsMessage() -> String {
        statisticService.store(correct: correctAnswers, total: questionsAmount)

        let bestGame = statisticService.bestGame
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total) (\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"

        return [currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine].joined(separator: "\n")
    }

    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let image = UIImage(data: model.image) ?? UIImage()
        return QuizStepViewModel(
            image: image,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
}
