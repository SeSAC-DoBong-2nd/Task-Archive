//
//  NetworkService.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/27/25.
//

import Foundation

enum APIError: Error {
    case invalidResponse
    case unknown
    case invalidImage
    case invalidURL(String)
    case unknownResponse
    case statusError
}

final class NetworkService: NetworkServiceProvider {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func callRequest<T: Decodable>(api: APIRouter, type: T.Type) async throws -> T {
        // 1. URL 유효성 검사
        guard let url = api.endpoint else {
            throw APIError.invalidURL("잘못된 URL입니다.")
        }
        
        // 2. URLRequest 구성
        var request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
        request.httpMethod = String(describing: api.method)
        request.allHTTPHeaderFields = api.headers
        
        Log.d("\(url) 요청 시작")
        
        // 3. 네트워크 요청 실행
        let (data, response) = try await session.data(for: request)
        
        Log.d("\(url) 결과 수신")
        
        // 4. HTTP 응답 확인
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        // 5. 상태 코드 검증
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.statusError
        }
        
        // 6. 데이터 디코딩
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch {
            print("디코딩 에러: \(error)")
            throw APIError.unknownResponse
        }
    }
    
}
