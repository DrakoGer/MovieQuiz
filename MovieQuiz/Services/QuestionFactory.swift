//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Yura on 16.11.24.
//

import UIKit
import Foundation

public class QuestionFactory: QuestionFactoryProtocol {
    
    private let moviesLoader: MoviesLoading
    weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var questionFactory: QuestionFactoryProtocol?
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func setup(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    func resetQuestions() {
        currentQuestionIndex = 0
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else {
                return }
            do {
                let imageData = try Data(contentsOf: movie.imageURL)
                
                let rating = Float(movie.rating ?? "0.0") ?? 0.0
                let text = "Рейтинг этого фильма больше чем 8.5?"
                let correctAnswer = rating > 8.5
                
                let question = QuizQuestion(image: imageData, text: text, correctAnswer: correctAnswer)
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didReceiveNextQuestion(question: question)
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
}
