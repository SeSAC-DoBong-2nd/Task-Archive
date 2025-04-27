//
//  iTunesRouter.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/27/25.
//

import Foundation

enum iTunesRouter: APIRouter {
    case search(term: String)
    case lookup(trackId: Int)
}

extension iTunesRouter {
    
    var baseURL: URL? {
        return URL(string: "https://itunes.apple.com")
    }
    
    var path: String {
        switch self {
        case .search:
            return "/search"
        case .lookup:
            return "/lookup"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .search(let term):
            return [
                "term": term,
                "country": "kr",
                "media": "software",
                "entity": "software",
                "limit": "15"
            ]
        case .lookup(let trackId):
            return [
                "id": trackId,
                "country": "kr"
            ]
        }
    }
    
    var endpoint: URL? {
        guard let baseURL = baseURL else { return nil }
        
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true)
        
        if let parameters = parameters, method == .get {
            components?.queryItems = parameters.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
        }
        
        return components?.url
    }
    
    var headers: [String: String] {
        return ["Content-Type": "application/json"]
    }
    
}


