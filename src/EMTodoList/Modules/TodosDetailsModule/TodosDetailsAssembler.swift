//
//  TodosDetailsAssembler.swift
//  EMTodoList
//
//  Created by Mikhail Bereberdin on 03.02.2025.
//

import Foundation

/// ``ITodosDetailsAssembler``.
public final class TodosDetailsAssembler: ITodosDetailsAssembler {
    
    // MARK: - Methods
    
    public func assemble(with view: ITodosDetailsView) {
        let presenter = TodosDetailsPresenter(view: view, dateFormatter: EMTLTodoDateFormatter())
        let interactor = TodosDetailsInteractor(presenter: presenter)
        
        view.presenter = presenter
        presenter.interactor = interactor
    }
}
