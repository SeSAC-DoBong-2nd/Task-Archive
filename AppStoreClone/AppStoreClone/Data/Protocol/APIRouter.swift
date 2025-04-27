//
//  APIRouter.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/27/25.
//

import Foundation

protocol APIRouter {
    var baseURL: URL? { get }
    var endpoint: URL? { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String] { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
