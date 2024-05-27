//
//  NetworkAPIDefinition.swift
//  REST_TODO
//
//  Created by 준우의 MacBook 16 on 5/20/24.
//

import Combine
import Foundation

protocol NetworkAPIDefinition {
    typealias URLInfo = NetworkAPI.URLInfo
    typealias RequestInfo = NetworkAPI.RequestInfo

    associatedtype Parameter: Encodable
    associatedtype Response: Decodable

    var urlInfo: URLInfo { get }
    var requestInfo: RequestInfo<Parameter> { get }
}

enum Filter: String {
    case createdAt = "created_at"
    case updatedAt = "updated_at"
}

enum Order: String {
    case desc
    case asc
}

enum NetworkAPI {}

extension NetworkAPI {
    struct URLInfo {
        let scheme: String
        let host: String
        let port: Int?
        let path: String
        let query: [String: String]?

        public init(scheme: String = Constants.scheme,
                    host: String,
                    port: Int? = nil,
                    path: String,
                    query: [String: String]? = nil)
        {
            self.scheme = scheme
            self.host = host
            self.port = port
            self.path = path
            self.query = query
        }
    }
}

extension NetworkAPI {
    enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
}

extension NetworkAPI {
    struct RequestInfo<T: Encodable> {
        var method: Method
        var headers: [String: String]?
        var parameters: T?

        public init(method: NetworkAPI.Method,
                    headers: [String: String]? = nil,
                    parameters: T? = nil)
        {
            self.method = method
            self.headers = headers
            self.parameters = parameters
        }
    }
}

extension NetworkAPI.URLInfo {
    var url: URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.port = port
        components.path = path
        components.queryItems = query?.compactMap { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = components.url else {
            assertionFailure("URL 정보를 확인해주세요.")
            return .init(string: "https://\(host)")!
        }
        return url
    }
}

extension NetworkAPI.RequestInfo {
    func requests(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = parameters.flatMap { try? JSONEncoder().encode($0) }
        headers.map {
            request.allHTTPHeaderFields?.merge($0) { lhs, rhs in lhs }
        }

        return request
    }
}
