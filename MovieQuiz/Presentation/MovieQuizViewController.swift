import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    // MARK: - Model
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    
    private var alertPresenter: AlertPresenter?
    
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    private var statisticService: StatisticServiceProtocol!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.contentMode = .scaleAspectFill
        
        alertPresenter = AlertPresenter()
        statisticService = StatisticService()

        activityIndicator.hidesWhenStopped = false
        
        questionFactory = QuestionFactory (moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        
        resetGame()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        handleAnswer(givenAnswer: true)
        
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        handleAnswer(givenAnswer: false)
    }
    // MARK: - Private functions
    // метод работы кнопок "Да"/"Нет"
    private func handleAnswer(givenAnswer: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        yesButton.isEnabled = false
        noButton.isEnabled = false
        let isCorrect = givenAnswer == currentQuestion.correctAnswer
        showAnswerResult(isCorrect: isCorrect)
    }
    // метод конвертации вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
        return questionStep
    }
    // метод для перехода к следующему вопросу / показа результатов
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            
            let text = """
                            Ваш результат: \(correctAnswers)/\(questionsAmount)
                            Количество сыгранных квизов: \(statisticService.gamesCount)
                            Рекорд по квизам: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total)               (\(statisticService.bestGame.date.dateTimeString))
                            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
                        """
            
            
            let viewModel = QuizResultViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            
            show(quiz: viewModel)
            
            yesButton.isEnabled = true
            noButton.isEnabled = true
            
        } else {
            currentQuestionIndex += 1  //для перехода к следующему вопросу
            questionFactory?.loadData()
            
            yesButton.isEnabled = true
            noButton.isEnabled = true
        }
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating() // для анимации
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    // алерт ошибки загрузки
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let errorAlert = AlertModel(title: "Ошибка",
                                    message: message,
                                    buttonText: "Попробуйте еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            self.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter?.showAlert(on: self, with: errorAlert)
    }
    
    public func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }
    
    public func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }
    
    private func resetGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        
        yesButton.isEnabled = true
        noButton.isEnabled = true
        
        questionFactory?.resetQuestions()
        questionFactory?.requestNextQuestion()
        
    }
    // метод для смены цвета рамки, в зависимости от ответа
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        if isCorrect {
            correctAnswers += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {  // для задержки отображения рамки
            self.imageView.layer.borderColor = UIColor.clear.cgColor
            self.showNextQuestionOrResults()
        }
    }
    // метод для отображения текущего вопроса на экране
    private func show(quiz viewModel: QuizStepViewModel) {
        imageView.isHidden = false  // false делает изображение видимым
        imageView.image = viewModel.image  // изображение вопроса
        textLabel.text = viewModel.question  // текст вопроса
        counterLabel.text = viewModel.questionNumber  // номер вопроса
    }
    // метод для отображения итогового результата квиза
    private func show(quiz resultModel: QuizResultViewModel) {
        let errorModel = AlertModel(
            title: resultModel.title,
            message: resultModel.text,
            buttonText: resultModel.buttonText,
            completion: { [weak self] in
                self?.resetGame()
            }
        )
        alertPresenter?.showAlert(on: self, with: errorModel)
    }
}


/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
