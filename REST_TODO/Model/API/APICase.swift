//
//  APICase.swift
//  REST_TODO
//
//  Created by 준우의 MacBook 16 on 5/27/24.
//

import Foundation

enum APICase {
    case getTodo(dto: ToDoIDDTO)
    case getTodos(page: Int)
    case getNonCompletedTodos(page: Int, isDone: Bool)
    case getSearchTodos(dto: ToDoQueryDTO)
    case postTodo(dto: ToDoBodyDTO)
    case putToDo(idDTO: ToDoIDDTO, bodyDTO: ToDoBodyDTO)
    case deleteTodo(dto: ToDoIDDTO)

    case infiniteScrolling(page: Int)
    case infiniteScrollingNonCompleted(page: Int, isDone: Bool)
    case infiniteScrollingWithQuery(dto: ToDoQueryDTO)

    var api: any NetworkAPIDefinition {
        switch self {
        case .getTodo(let dto):
            return GETTodoAPI(dto: dto)
            
        case .getTodos(let page):
            return GETTodosAPI(
                page: page.description,
                filter: Filter.createdAt.rawValue,
                orderBy: Order.desc.rawValue,
                perPage: 10.description
            )

        case .getNonCompletedTodos(let page, let isDone):
            return GETHideCompletedTodosAPI(
                page: page.description,
                filter: Filter.createdAt.rawValue,
                orderBy: Order.desc.rawValue,
                perPage: 10.description,
                isDone: isDone.description
            )

        case .getSearchTodos(let dto):
            return GETSearchToDosAPI(dto: dto)
            
        case .postTodo(let dto):
            return POSTToDoAPI(dto: dto)
            
        case .putToDo(let idDTO, let bodyDTO):
            return PUTToDoAPI(idDTO: idDTO, bodyDTO: bodyDTO)

        case .deleteTodo(let dto):
            return DELETEToDoAPI(dto: dto)

        case .infiniteScrolling(let page):
            return GETTodosAPI(
                page: page.description,
                filter: Filter.createdAt.rawValue,
                orderBy: Order.desc.rawValue,
                perPage: 10.description
            )

        case .infiniteScrollingNonCompleted(let page, let isDone):
            return GETHideCompletedTodosAPI(
                page: page.description,
                filter: Filter.createdAt.rawValue,
                orderBy: Order.desc.rawValue,
                perPage: 10.description,
                isDone: isDone.description
            )

        case .infiniteScrollingWithQuery(let dto):
            return GETSearchToDosAPI(dto: dto)
        }
    }
}
