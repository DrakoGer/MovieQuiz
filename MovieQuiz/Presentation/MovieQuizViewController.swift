import UIKit

final class MovieQuizViewController: UIViewController {
    private var presenter: MovieQuizPresenter!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private weak var textLabel: UILabel!//
    
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
    }

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }

    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }

    func show(quiz result: QuizResultViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            self?.presenter.restartGame()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }

    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }

    func showNetworkError(message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "Попробовать ещё раз", style: .default) { [weak self] _ in
            self?.presenter.restartGame()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}







//final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
//    
//    // MARK: - Outlets
//    @IBOutlet private weak var imageView: UIImageView!//
//    @IBOutlet private weak var textLabel: UILabel!//
  //
//    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!//
//    
//    @IBOutlet private weak var yesButton: UIButton!
//    @IBOutlet private weak var noButton: UIButton!
//    
//    // MARK: - Model
//    
//    //private let questionsAmount: Int = 10//
//    //private var currentQuestionIndex: Int = 0//
//    private var correctAnswers: Int = 0//
//    
//    private var questionFactory: QuestionFactoryProtocol?
//
//    private var statisticService: StatisticServiceProtocol?
//    
//    private var alertPresenter: AlertPresenter?
//    
//    private var presenter = MovieQuizPresenter()
//    
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        imageView.layer.masksToBounds = true
//        imageView.layer.borderWidth = 8
//        imageView.layer.borderColor = UIColor.clear.cgColor
//        imageView.contentMode = .scaleAspectFill
//        
//        questionFactory = QuestionFactory (moviesLoader: MoviesLoader(), delegate: self)
//        statisticService = StatisticService()
//        
//        alertPresenter = AlertPresenter()
//        
//        questionFactory?.loadData()
//        activityIndicator.hidesWhenStopped = true
//        
//        resetGame()
//    }
//    
//    // MARK: - QuestionFactoryDelegate

//    
//    func didLoadDataFromServer() {
//        showLoadingIndicator()
//        questionFactory?.requestNextQuestion()
//    }
//    
//    func didFailToLoadData(with error: Error) {
//        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
//    }
//    
//    // MARK: - Actions
//
//
//    // MARK: - Private functions
//    // метод работы кнопок "Да"/"Нет"
//
//    // метод конвертации вопроса
////    private func convert(model: QuizQuestion) -> QuizStepViewModel {
////        let questionStep = QuizStepViewModel(
////            image: UIImage(data: model.image) ?? UIImage(),
////            question: model.text,
////            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
////        )
////        return questionStep
////    }
//    // метод для перехода к следующему вопросу / показа результатов
//    private func showNextQuestionOrResults() {
//        guard let statisticService = statisticService else { return }
//        
//        if presenter.isLastQuestion() { // Проверяем, последний ли вопрос
//            statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)
//            
//            let text = """
//                Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)
//                Количество сыгранных квизов: \(statisticService.gamesCount)
//                Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
//                Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
//            """
//            
//            let viewModel = QuizResultViewModel(
//                title: "Этот раунд окончен!",
//                text: text,
//                buttonText: "Сыграть ещё раз")
//            
//            show(quiz: viewModel)
//            
//            yesButton.isEnabled = true
//            noButton.isEnabled = true
//            
//        } else {
//            presenter.switchToNextQuestion() // Сбрасываем индекс через презентер
//            correctAnswers = 0
//            
//            yesButton.isEnabled = true
//            noButton.isEnabled = true
//            
//            questionFactory?.requestNextQuestion()
//        }
//    }
//    
//    private func showLoadingIndicator() {
//        activityIndicator.startAnimating() // для анимации
//    }
//    
//    private func hideLoadingIndicator() {
//        activityIndicator.stopAnimating()
//        
//    }
//    // алерт ошибки загрузки
//    private func showNetworkError(message: String) {
//        let errorAlert = AlertModel(title: "Ошибка",
//                                    message: message,
//                                    buttonText: "Попробуйте еще раз") { [weak self] in
//            guard let self = self else { return }
//            
//            //self.currentQuestionIndex = 0
//            self.correctAnswers = 0
//            
//            self.questionFactory?.requestNextQuestion()
//        }
//        
//        alertPresenter?.showAlert(on: self, with: errorAlert)
//    }
//    
//    private func resetGame() {
//        //currentQuestionIndex = 0
//        correctAnswers = 0
//        
//        yesButton.isEnabled = true
//        noButton.isEnabled = true
//        
//        questionFactory?.requestNextQuestion()
//        
//    }
//    // метод для смены цвета рамки, в зависимости от ответа
//    private func showAnswerResult(isCorrect: Bool) {
//        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
//        
//        if isCorrect {
//            correctAnswers += 1
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in // Используем weak self
//            guard let self = self else { return }  // для задержки отображения рамки
//            self.imageView.layer.borderColor = UIColor.clear.cgColor
//            self.showNextQuestionOrResults()
//        }
//    }
//    // метод для отображения текущего вопроса на экране
//    private func show(quiz viewModel: QuizStepViewModel) {
//        hideLoadingIndicator()
//        imageView.isHidden = false  // false делает изображение видимым
//        imageView.image = viewModel.image  // изображение вопроса
//        textLabel.text = viewModel.question  // текст вопроса
//        counterLabel.text = viewModel.questionNumber  // номер вопроса
//    }
//    // метод для отображения итогового результата квиза
//    private func show(quiz resultModel: QuizResultViewModel) {
//        let errorModel = AlertModel(
//            title: resultModel.title,
//            message: resultModel.text,
//            buttonText: resultModel.buttonText,
//            completion: { [weak self] in
//                self?.resetGame()
//            }
//        )
//        alertPresenter?.showAlert(on: self, with: errorModel)
//    }
//}
