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
    
    /// Надпись количества задач.
    private var todosCountLabel: UILabel!
    
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
        self.configureToolBar()
        
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
    
    public func setTodosCountLabelText(_ text: String?) {
        self.todosCountLabel.text = text
        self.todosCountLabel.sizeToFit()
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

// MARK: - UISearchResultsUpdating extensions
extension TodosView: UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        self.presenter.updateIsFilteringActive(searchController.isActive)
        self.presenter.filterTodos(by: searchController.searchBar.text)
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
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    /// Настроить элемент навигации.
    private func configureNavigationItem() {
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
        ]
        
        self.navigationItem.scrollEdgeAppearance = {
            let scrollEdgeAppearance = UINavigationBarAppearance()
            scrollEdgeAppearance.configureWithOpaqueBackground()
            scrollEdgeAppearance.shadowColor = .clear
            scrollEdgeAppearance.backgroundColor = .black
            
            scrollEdgeAppearance.titleTextAttributes = titleTextAttributes
            scrollEdgeAppearance.largeTitleTextAttributes = titleTextAttributes
            
            return scrollEdgeAppearance
        }()
        
        self.navigationItem.standardAppearance = {
            let standartAppearance = UINavigationBarAppearance()
            standartAppearance.configureWithDefaultBackground()
            standartAppearance.backgroundColor = .barsBackground
            
            standartAppearance.titleTextAttributes = titleTextAttributes
            standartAppearance.largeTitleTextAttributes = titleTextAttributes
            
            return standartAppearance
        }()
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.barStyle = .black
        searchController.searchBar.tintColor = .systemYellow
        
        self.navigationItem.searchController = searchController
    }
    
    /// Настроить панель инструментов.
    private func configureToolBar() {
        self.todosCountLabel = UILabel()
        self.todosCountLabel.font = .systemFont(ofSize: 11)
        self.todosCountLabel.textColor = .white
        
        let createTodoButton = {
            let image = UIImage(systemName: "square.and.pencil")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 22))
            let barButton = UIBarButtonItem(image: image, style: .plain, target: self, action: nil)
            barButton.tintColor = .systemYellow
            
            return barButton
        }()
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        self.setToolbarItems([spacer, UIBarButtonItem(customView: self.todosCountLabel), spacer, createTodoButton], animated: false)
        
        self.hidesBottomBarWhenPushed = true
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
        
        self.todosTable.backgroundColor = self.view.backgroundColor
        self.todosTable.indicatorStyle = .white
        
        self.todosTable.register(EMTLTodoCell.self, forCellReuseIdentifier: EMTLTodoCell.reuseIdentifier)
    }
}
