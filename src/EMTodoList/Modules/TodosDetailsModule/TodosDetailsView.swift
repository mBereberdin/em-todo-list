//
//  TodosDetailsView.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 03.02.2025.
//

import UIKit

import SnapKit

/// ``ITodosDetailsView``.
public final class TodosDetailsView: UIViewController {
    
    // MARK: - UI
    
    /// Текстовое поле заголовка.
    private var titleTextField: UITextField!
    
    /// Надпись даты.
    private var dateLabel: UILabel!
    
    /// Представление текста деталей задачи.
    private var detailsTextView: UITextView!
    
    // MARK: - Fields
    
    public var presenter: ITodosDetailsPresenter!
    
    public var assembler: ITodosDetailsAssembler = TodosDetailsAssembler()
    
    // MARK: - Inits
    
    /// ``ITodosDetailsView``.
    ///
    /// - Parameters:
    ///   - nibNameOrNil: Наименование файла, описывающего пользовательский интерфейс.
    ///   - nibBundleOrNil: Сборка файла, описывающего пользовательский интерфейс.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.assembler.assemble(with: self)
        
        self.hidesBottomBarWhenPushed = true
    }
    
    /// ``ITodosDetailsView``.
    ///
    /// - Parameter coder: Кодировщик.
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    
    /// Представление было загружено.
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter.viewDidLoad()
    }
    
    // MARK: - Private
    
    /// Представление было нажато.
    @objc private func viewTapped() {
        self.presenter.viewTapped()
    }
}

// MARK: - ITodosDetailsView extensions
extension TodosDetailsView: ITodosDetailsView {
    
    public func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    public func addViewTapRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))
        self.view.addGestureRecognizer(tap)
    }
    
    public func configureUI() {
        self.configureView()
        
        self.configureTitleTextField()
        self.configureDateLabel()
        self.configureDetailsTextView()
    }
    
    public func showAlert(title: String, description: String) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    public func setTitle(_ text: String?) {
        self.titleTextField.text = text
    }
    
    public func setDate(_ date: String?) {
        self.dateLabel.text = date
    }
    
    public func setDetails(_ details: String?) {
        self.detailsTextView.text = details
    }
    
    public func provideTodo(_ todo: Todo) {
        self.presenter.provideTodo(todo)
    }
}

// MARK: - ITodosDetailsView defaults extensions
extension ITodosDetailsView {
    
    public func showAlert(title: String = "Ошибка", description: String) {
        self.showAlert(title: title, description: description)
    }
}

// MARK: - Configure UI extensions
extension TodosDetailsView {
    
    /// Настроить представление.
    private func configureView() {
        self.view.backgroundColor = .black
    }
    
    /// Настроить надпись заголовка.
    private func configureTitleTextField() {
        self.titleTextField = UITextField()
        
        self.view.addSubview(self.titleTextField)
        
        self.titleTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(8)
            make.trailing.equalToSuperview().inset(20)
        }
        
        self.titleTextField.font = .systemFont(ofSize: 34, weight: .bold)
        self.titleTextField.textColor = .white
        self.titleTextField.placeholder = "Введите название"
        self.titleTextField.tintColor = .systemYellow
    }
    
    /// Настроить надпись даты.
    private func configureDateLabel() {
        self.dateLabel = UILabel()
        
        self.view.addSubview(self.dateLabel)
        
        self.dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(self.titleTextField.snp.bottom).offset(8)
            make.trailing.equalToSuperview().inset(20)
        }
        
        self.dateLabel.textColor = .white.withAlphaComponent(0.5)
        self.dateLabel.font = .systemFont(ofSize: 12)
    }
    
    /// Настроить представление текста деталей задачи.
    private func configureDetailsTextView() {
        self.detailsTextView = UITextView()
        
        self.view.addSubview(self.detailsTextView)
        
        self.detailsTextView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(self.dateLabel.snp.bottom).offset(16)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
        
        self.detailsTextView.backgroundColor = self.view.backgroundColor
        self.detailsTextView.textColor = .white
        self.detailsTextView.font = .systemFont(ofSize: 16)
        self.detailsTextView.tintColor = .systemYellow
        self.detailsTextView.isScrollEnabled = true
        self.detailsTextView.indicatorStyle = .white
        
        // Лучше добавить уведомление для отслеживания появления клавиатуры из которого можно будет брать высоту клавиатуры и задавать смещение относительно этого параметра, но на это нужно время.
        self.detailsTextView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 340, right: 0)
    }
}
