import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    // MARK: - Model
    private struct ViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }

    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
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
    

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.contentMode = .scaleAspectFill
        
        let questionFactory = QuestionFactory()
        questionFactory.delegate = self
        self.questionFactory = questionFactory
        
        questionFactory.requestNextQuestion()
    }
    
    // MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        handleAnswer(givenAnswer: true)

    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        handleAnswer(givenAnswer: false)
    }
    
    // MARK: - Private functions
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
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
        return questionStep
    }
    // метод для перехода к следующему вопросу / показа результатов
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            let text = correctAnswers == questionsAmount ?
            "Поздравляю, вы ответили на 10 из 10!" :
            "Ваш ответили на \(correctAnswers) из 10, попробуйте еще раз!"
            
            let viewModel = QuizResultViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз"
            )
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()

            yesButton.isEnabled = true
            noButton.isEnabled = true
        }
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
        textLabel.text = resultModel.title  // заголовок
        imageView.isHidden = false  // false делает изображение видимым
        counterLabel.text = resultModel.text  // текст результата
        // Алерт для отображения сообщения о завершении игры
        let alert = UIAlertController(
            title: resultModel.title,
            message: resultModel.text,
            preferredStyle: .alert
        )
        // действие "Новая игра" для сброса игры и начала заново
        let newGameAction = UIAlertAction(title: resultModel.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
            
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        }
        alert.addAction(newGameAction)
        self.present(alert, animated: true, completion: nil)  // показывает всплывающее окно
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
