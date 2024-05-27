//
//  GETTodosAPI.swift
//  REST_TODO
//
//  Created by 준우의 MacBook 16 on 5/23/24.
//

import Foundation

// 모든 할일 목록 가져오기 - 완료 숨김 X
struct GETTodosAPI: NetworkAPIDefinition {
    let page: String
    let filter: String
    let orderBy: String
    let perPage: String

    // BODY Parameter
    struct Parameter: Encodable {
        // Parameters for the GET request
    }

    typealias Response = ToDos

    var urlInfo: NetworkAPI.URLInfo {
        NetworkAPI.URLInfo(
            host: Constants.host,
            path: Constants.path,
            query: [
                "page": page,
                "filter": filter,
                "order_by": orderBy,
                "per_page": perPage,
            ]
        )
    }

    var requestInfo: NetworkAPI.RequestInfo<Parameter> {
        NetworkAPI.RequestInfo(
            method: .get,
            headers: [Constants.accept: Constants.applicationJson]
        )
    }
}

// 모든 할일 목록 가져오기 - 완료 숨김 O
struct GETHideCompletedTodosAPI: NetworkAPIDefinition {
    let page: String
    let filter: String
    let orderBy: String
    let perPage: String
    let isDone: String

    // BODY Parameter
    struct Parameter: Encodable {
        // Parameters for the GET request
    }

    typealias Response = ToDos

    var urlInfo: NetworkAPI.URLInfo {
        NetworkAPI.URLInfo(
            host: Constants.host,
            path: Constants.path,
            query: [
                "page": page,
                "filter": filter,
                "order_by": orderBy,
                "per_page": perPage,
                "is_done": isDone,
            ]
        )
    }

    var requestInfo: NetworkAPI.RequestInfo<Parameter> {
        NetworkAPI.RequestInfo(
            method: .get,
            headers: [Constants.accept: Constants.applicationJson]
        )
    }
}

// 특정 할일 가져오기 - ID 기반
struct GETTodoAPI: NetworkAPIDefinition {
    let dto: ToDoIDDTO

    struct Parameter: Encodable {
        // Parameters for the GET request
    }

    typealias Response = ToDo

    var urlInfo: NetworkAPI.URLInfo {
        NetworkAPI.URLInfo(
            host: Constants.host,
            path: "\(Constants.path)/\(dto.id)"
        )
    }

    var requestInfo: NetworkAPI.RequestInfo<Parameter> {
        NetworkAPI.RequestInfo(
            method: .get,
            headers: [Constants.accept: Constants.applicationJson]
        )
    }
}

// 검색 데이터 가져오기
struct GETSearchToDosAPI: NetworkAPIDefinition {
    let dto: ToDoQueryDTO

    struct Parameter: Encodable {
        // Parameters for the GET request
    }

    typealias Response = ToDos

    var urlInfo: NetworkAPI.URLInfo {
        NetworkAPI.URLInfo(
            host: Constants.host,
            path: Constants.searchPath,
            query: [
                "query": dto.query,
                "filter": dto.filter,
                "order_by": dto.orderBy,
                "page": dto.page,
                "per_page": dto.perPage,
            ]
        )
    }

    var requestInfo: NetworkAPI.RequestInfo<Parameter> {
        NetworkAPI.RequestInfo(
            method: .get,
            headers: [Constants.accept: Constants.applicationJson]
        )
    }
}
