import UIKit

final class MovieQuizViewController: UIViewController {
    
    // аутлеты для элементов интерфейса
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    // структур модели главного экрана
    private struct ViewModel {
        // изображение вопроса
        let image: UIImage
        // текст вопроса
        let question: String
        // номер текущего вопроса
        let questionNumber: String
    }
    // для показа вопроса в квизе
    private struct QuizQuestion {
        // название фильма, совпадает с названием изображения в Assets
        let image: String
        // вопроса о рейтинге фильма
        let text: String
        // булевое значение правильного ответа Да(True) Нет(False)
        let correctAnswer: Bool
    }
    // для отображения экрана при показе текущего вопроса
    private struct QuizStepViewModel {
        // изображение вопроса
        let image: UIImage
        // текст вопроса
        let question: String
        // номер вопроса (1/10)
        let questionNumber: String
    }
    // для отображения результата квиза
    private struct QuizResultViewModel {
        // заголовок итогового окна
        let title: String
        // сообщение об итогах квиза
        let text: String
        // текст на кнопке для перезапуска игры
        let buttonText: String
    }
    // список вопросов для квиза
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "The Dark Knight",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "Kill Bill",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "The Avengers",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "Deadpool",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "The Green Knight",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "Old",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(image: "Tesla",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(image: "Vivarium",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false)
    ]
    // индекс текущего вопроса
    private var currentQuestionIndex = 0
    // счётчик правильных ответов
    private var correctAnswers = 0

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.contentMode = .scaleAspectFill
        // отображение первого вопроса при загрузке экрана
        let firstQuestion = questions[currentQuestionIndex]
        let viewModel = convert(model: firstQuestion)
        show(quiz: viewModel)
        
        let restartQuestion = questions[currentQuestionIndex]
        let resultModel = convert(model: restartQuestion)
        show(quiz: resultModel)
    }
    // действия нажатия на кнопку "Да"
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let giveAnswer = true
        handleAnswer(givenAnswer: false)
        
    }
    // действия нажатия на кнопку "Нет"
    @IBAction private func noButtonClicked(_ sender: UIButton) {

        let giveAnswer = false
        handleAnswer(givenAnswer: false)
    }
    
    private func handleAnswer(givenAnswer: Bool) {
        let currentQuestion = questions[currentQuestionIndex]
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
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
        )
        return questionStep
    }
    // метод для перехода к следующему вопросу / показа результатов
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат: \(correctAnswers)/\(questions.count)"
            let viewModel = QuizResultViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз"
            )
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1  // для перехода к следующему вопросу

            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            show(quiz: viewModel)  // для отображения следующего вопроса
            
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
            
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)  
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
