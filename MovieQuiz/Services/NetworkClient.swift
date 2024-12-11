//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Yura on 03.12.24.
//

import Foundation

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}

/// Отвечает за загрузку данных по URL
struct NetworkClient: NetworkRouting {
    
    private enum NetworkError: Error { //реализация протокола Error!
        case codeError
    }
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url) // создаём запрос из url
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Проверяем, пришла ли ошибка
            if let error = error {
                handler(.failure(error))
                return // дальше продолжать не имеет смысла, так что заканчиваем выполнение этого кода
            }
            // Проверяем, что нам пришёл успешный код ответа
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return // дальше продолжать не имеет смысла, так что заканчиваем выполнение этого кода
            }
            // Возвращаем данные
            guard let data = data else { return }
            handler(.success(data))
        }
        task.resume()
    }
}
