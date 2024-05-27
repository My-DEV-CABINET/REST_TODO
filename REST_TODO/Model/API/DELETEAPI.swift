//
//  DELETEAPI.swift
//  REST_TODO
//
//  Created by 준우의 MacBook 16 on 5/20/24.
//

import Foundation

// 기존 할일 삭제하기 - ID 기반
struct DELETEToDoAPI: NetworkAPIDefinition {
    let dto: ToDoIDDTO

    struct Parameter: Encodable {
        // Parameters for the DELETE request
    }

    struct Response: Decodable {
        // Response for the DELETE request
    }

    var urlInfo: NetworkAPI.URLInfo {
        NetworkAPI.URLInfo(
            host: Constants.host,
            path: "\(Constants.path)/\(dto.id)"
        )
    }

    var requestInfo: NetworkAPI.RequestInfo<Parameter> {
        NetworkAPI.RequestInfo(
            method: .delete,
            headers: [Constants.accept: Constants.applicationJson]
        )
    }
}
