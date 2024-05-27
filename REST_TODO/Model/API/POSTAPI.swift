//
//  POSTAPI.swift
//  REST_TODO
//
//  Created by 준우의 MacBook 16 on 5/23/24.
//

import Foundation

// 할일 추가
struct POSTToDoAPI: NetworkAPIDefinition {
    let dto: ToDoBodyDTO

    struct Parameter: Encodable {
        let title: String
        let is_done: Bool
    }

    struct Response: Decodable {
        // Response for the POST request
    }

    var urlInfo: NetworkAPI.URLInfo {
        NetworkAPI.URLInfo(
            host: Constants.host,
            path: Constants.postPath
        )
    }

    var requestInfo: NetworkAPI.RequestInfo<Parameter> {
        NetworkAPI.RequestInfo(
            method: .post,
            headers: [
                Constants.accept: Constants.applicationJson,
                Constants.contentType: Constants.applicationJson,
            ],
            parameters: Parameter(
                title: dto.title,
                is_done: dto.is_Done
            )
        )
    }
}
