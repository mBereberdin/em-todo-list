//
//  TodosAssembler.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 30.01.2025.
//

import Foundation

/// ``ITodosAssembler``.
public final class TodosAssembler: ITodosAssembler {
    
    // MARK: - Methods
    
    public func assemble(with view: ITodosView) {
        let router = TodosRouter(view: view)
        let presenter = TodosPresenter(view: view, dateFormatter: EMTLTodoDateFormatter())
        let interactor = TodosInteractor(presenter: presenter, context: CoreDataStack.shared.persistentContainer.viewContext,
                                         settingsRepository: SettingsRepository(), todosRepository: TodosRepository(),
                                         todosService: TodosService())
        
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
