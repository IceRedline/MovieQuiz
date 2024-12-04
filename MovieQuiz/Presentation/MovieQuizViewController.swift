import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var questionLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    private var alertPresenter: AlertPresenter?
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        
        let alertPresenter = AlertPresenter()
        alertPresenter.viewController = self
        self.alertPresenter = alertPresenter
    }
    
    func showLoadingIndicator() {
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }
    
    func disableButtons() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alert = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать ещё раз") { [weak self] in
            guard let self else { return }
            
            self.presenter.restartGame()
            
            presenter.questionFactory?.loadData() // оставлено тут, т.к. если перенести в restartGame, то при рестарте будут пролистываться 2 фильма
        }
        alertPresenter?.show(with: alert)
    }
    
    // Вывести на экран вопрос (принимает вью модель вопроса и ничего не возвращает)
    func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        imageView.layer.borderWidth = 0
        questionLabel.text = step.question
        
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    
    @IBAction private func yesButtonTapped() {
        presenter.yesButtonTapped()
    }
    
    @IBAction private func noButtonTapped() {
        presenter.noButtonTapped()
    }
    
    func highlightImageBorder(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    // Показать результат квиза
    func showQuizResult(result: QuizResultsViewModel) {
        let alertModel = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            completion: { [weak self] in
                guard let self = self else { return }
                
                self.presenter.restartGame()
                self.imageView.layer.borderWidth = 0
            }
        )
        alertPresenter?.show(with: alertModel) // выводим алерт
    }
}
