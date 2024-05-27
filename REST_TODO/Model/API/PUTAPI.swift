//
//  PUTAPI.swift
//  REST_TODO
//
//  Created by 준우의 MacBook 16 on 5/23/24.
//

import Foundation

// 특정 할일 수정 - ID 기반
struct PUTToDoAPI: NetworkAPIDefinition {
    let idDTO: ToDoIDDTO
    let bodyDTO: ToDoBodyDTO

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
            path: "\(Constants.path)/\(idDTO.id)"
        )
    }

    var requestInfo: NetworkAPI.RequestInfo<Parameter> {
        NetworkAPI.RequestInfo(
            method: .put,
            headers: [
                Constants.accept: Constants.applicationJson,
                Constants.contentType: Constants.applicationXw3FormUrlencoded,
            ],
            parameters: Parameter(
                title: bodyDTO.title,
                is_done: bodyDTO.is_Done
            )
        )
    }
}
