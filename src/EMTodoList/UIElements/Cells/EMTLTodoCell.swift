//
//  EMTLTodoCell.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 30.01.2025.
//

import UIKit

import SnapKit

/// Ячейка таблицы задач.
public final class EMTLTodoCell: UITableViewCell {
    
    // MARK: - UI
    
    /// Контейнер содержимого ячейки.
    private var contentContainer: UIView!
    
    /// Кнопка завершенности задачи.
    private var isCompletedButton: UIButton!
    
    /// Контейнер элементов задачи.
    private var todosContainer: UIView!
    
    /// Надпись названия задачи.
    private var titleLabel: UILabel!
    
    /// Надпись описания задачи.
    private var detailsLabel: UILabel!
    
    /// Надпись даты создания задачи.
    private var creationDateLabel: UILabel!
    
    // MARK: - Fields
    
    /// Конфигурация символа кнопки завершенности.
    private let _symbolConfiguration: UIImage.SymbolConfiguration
    
    /// Завершена ли задача.
    private var _isCompleted: Bool
    
    /// Стандартная картинка флага завершенности задачи.
    private let DEFAULT_IS_COMPLETED_IMAGE: UIImage?
    
    /// Идентификатор для переиспользования.
    public static let reuseIdentifier = EMTLTodoCell.description()
    
    /// Блок кода, который необходимо выполнить при нажатии на кнопку завершенности задачи.
    public var onIsCompletedButtonTapped: (()->())?
    
    // MARK: - Inits
    
    /// ``EMTLTodoCell``.
    ///
    /// - Parameters:
    ///   - style: Стиль.
    ///   - reuseIdentifier: Идентификатор для переиспользования.
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self._symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 21, weight: .thin)
        self._isCompleted = false
        self.DEFAULT_IS_COMPLETED_IMAGE = UIImage(systemName: "circle")
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configureUI()
    }
    
    /// ``EMTLTodoCell``.
    ///
    /// - Parameter coder: Кодировщик.
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    /// Подготовить ячейку к переиспользованию.
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        self.onIsCompletedButtonTapped = nil
        
        self.setIsCompleted(false)
        self.setTitle(nil)
        self.setDetails(nil)
        self.setCreationDate(nil)
    }
    
    // MARK: - Private
    
    /// Кнопка завершенности задачи была нажата.
    @objc private func isCompletedButtonTapped() {
        self.setIsCompleted(!self._isCompleted)
        self.onIsCompletedButtonTapped?()
    }
    
    // MARK: - Methods
    
    /// Задать заголовок.
    ///
    /// - Parameter text: Заголовок, который необходимо задать.
    public func setTitle(_ text: String?) {
        self.titleLabel.text = text
    }
    
    /// Задать описание.
    ///
    /// - Parameter text: Описание, которое необходимо задать.
    public func setDetails(_ text: String?) {
        self.detailsLabel.text = text
    }
    
    /// Задать дату создания.
    ///
    /// - Parameter text: Дата создания, которую необходимо задать.
    public func setCreationDate(_ text: String?) {
        self.creationDateLabel.text = text
    }
    
    /// Задать флаг завершенности.
    ///
    /// > Tip: При смене значения изменяет стиль заголовка и описания ячейки, если они установлены.
    ///
    /// - Parameter text: Дата создания, которую необходимо задать.
    public func setIsCompleted(_ isCompleted: Bool = false) {
        self._isCompleted = isCompleted
        
        let image = self._isCompleted ? UIImage(systemName: "checkmark.circle") : self.DEFAULT_IS_COMPLETED_IMAGE
        self.isCompletedButton.setImage(image?.withConfiguration(self._symbolConfiguration), for: .normal)
        
        self.isCompletedButton.tintColor = self._isCompleted ? .systemYellow : .systemGray
        
        if let title = self.titleLabel.text {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 16, weight: .medium),
                .foregroundColor: self._isCompleted ? UIColor.white.withAlphaComponent(0.5) : UIColor.white,
                .strikethroughStyle: self._isCompleted ? NSUnderlineStyle.single.rawValue : 0,
                .strikethroughColor: UIColor.white.withAlphaComponent(0.5)
            ]
            
            self.titleLabel.attributedText = NSAttributedString(string: title, attributes: attributes)
        }
        
        if let details = self.detailsLabel.text {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: self._isCompleted ? UIColor.white.withAlphaComponent(0.5) : UIColor.white
            ]
            
            self.detailsLabel.attributedText =  NSAttributedString(string: details, attributes: attributes)
        }
    }
}

// MARK: - Configure ui extensions
extension EMTLTodoCell {
    
    /// Настроить ui.
    private func configureUI() {
        self.configureContentContainer()
    }
    
    /// Настроить контейнер содержимого ячейки.
    private func configureContentContainer() {
        self.contentContainer = UIView()
        
        self.contentView.addSubview(self.contentContainer)
        
        self.contentContainer.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.verticalEdges.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }
        
        // Наполнение контейнера содержимого ячейки
        self.configureIsCompletedButton()
        self.configureTodosContainer()
    }
    
    /// Настроить кнопку завершенности задачи.
    private func configureIsCompletedButton() {
        self.isCompletedButton = UIButton()
        
        self.contentContainer.addSubview(self.isCompletedButton)
        
        self.isCompletedButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.equalTo(48)
            make.width.equalTo(24)
        }
        
        self.isCompletedButton.setImage(self.DEFAULT_IS_COMPLETED_IMAGE?.withConfiguration(self._symbolConfiguration), for: .normal)
        self.isCompletedButton.tintColor = .systemGray
        
        self.isCompletedButton.addTarget(self, action: #selector(self.isCompletedButtonTapped), for: .touchUpInside)
    }
    
    /// Настроить контейнер элементов задачи.
    private func configureTodosContainer() {
        self.todosContainer = UIView()
        
        self.contentContainer.addSubview(self.todosContainer)
        
        self.todosContainer.snp.makeConstraints { make in
            make.leading.equalTo(self.isCompletedButton.snp.trailing).offset(8)
            make.verticalEdges.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        // Наполнение контейнера элементов задачи
        self.configureTitleLabel()
        self.configureDetailsLabel()
        self.configureCreationDateLabel()
    }
    
    /// Настроить надпись названия.
    private func configureTitleLabel() {
        self.titleLabel = UILabel()
        
        self.todosContainer.addSubview(self.titleLabel)
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.horizontalEdges.equalToSuperview()
        }
        
        self.titleLabel.textColor = .white
        self.titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    
    /// Настроить надпись описания.
    private func configureDetailsLabel() {
        self.detailsLabel = UILabel()
        
        self.todosContainer.addSubview(self.detailsLabel)
        
        self.detailsLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview()
        }
        
        self.detailsLabel.textColor = .white
        self.detailsLabel.font = UIFont.systemFont(ofSize: 12)
        self.detailsLabel.numberOfLines = 2
        self.detailsLabel.setContentHuggingPriority(.defaultHigh - 1, for: .vertical)
    }
    
    /// Настроить надпись даты создания.
    private func configureCreationDateLabel() {
        self.creationDateLabel = UILabel()
        
        self.todosContainer.addSubview(self.creationDateLabel)
        
        self.creationDateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.detailsLabel.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
        }
        
        self.creationDateLabel.textColor = .white.withAlphaComponent(0.5)
        self.creationDateLabel.font = UIFont.systemFont(ofSize: 12)
        self.creationDateLabel.setContentHuggingPriority(.defaultHigh - 2, for: .vertical)
    }
}
