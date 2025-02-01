//
//  TodosView.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 30.01.2025.
//


import UIKit

import SnapKit

/// ``ITodosView``.
public final class TodosView: UIViewController {
    
    // MARK: - UI
    
    /// Таблица задач.
    private var todosTable: UITableView!
    
    // MARK: - Fields
    
    public var presenter: ITodosPresenter!
    
    public var assembler: ITodosAssembler = TodosAssembler()
    
    // MARK: - View lifecycle
    
    /// Представление было загружено.
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.assembler.assemble(with: self)
        
        self.presenter.viewDidLoad()
    }
}

// MARK: - ITodosView extensions
extension TodosView: ITodosView {
    
    public func configureUI() {
        self.configureView()
        
        self.configureNavigationItem()
        
        self.configureTodosTable()
    }
    
    public func showAlert(title: String, description: String) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    public func reloadTodosTable() {
        self.todosTable.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource extensions
extension TodosView: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.getNumberOfRows()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.presenter.getCellFor(tableView: tableView, at: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter.didSelectCell(in: tableView, at: indexPath)
    }
}

// MARK: - ITodosView defaults extensions
extension ITodosView {
    
    public func showAlert(title: String = "Ошибка", description: String) {
        self.showAlert(title: title, description: description)
    }
}

// MARK: - Configure UI extensions
extension TodosView {
    
    /// Настроить представление.
    private func configureView() {
        self.title = "Задачи"
        self.view.backgroundColor = .black
    }
    
    /// Настроить элемент навигации.
    private func configureNavigationItem() {
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
        ]
        
        self.navigationItem.scrollEdgeAppearance = {
            let scrollEdgeAppearance = UINavigationBarAppearance()
            scrollEdgeAppearance.configureWithTransparentBackground()
            
            scrollEdgeAppearance.titleTextAttributes = titleTextAttributes
            scrollEdgeAppearance.largeTitleTextAttributes = titleTextAttributes
            
            return scrollEdgeAppearance
        }()
        
        self.navigationItem.standardAppearance = {
            let standartAppearance = UINavigationBarAppearance()
            standartAppearance.configureWithDefaultBackground()
            standartAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
            
            standartAppearance.titleTextAttributes = titleTextAttributes
            standartAppearance.largeTitleTextAttributes = titleTextAttributes
            
            return standartAppearance
        }()
    }
    
    /// Настроить таблицу задач.
    private func configureTodosTable() {
        self.todosTable = UITableView()
        
        self.view.addSubview(self.todosTable)
        
        self.todosTable.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
        
        self.todosTable.dataSource = self
        self.todosTable.delegate = self
        
        self.todosTable.rowHeight = UITableView.automaticDimension
        self.todosTable.estimatedRowHeight = 95
        self.todosTable.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        self.todosTable.register(EMTLTodoCell.self, forCellReuseIdentifier: EMTLTodoCell.reuseIdentifier)
    }
}
